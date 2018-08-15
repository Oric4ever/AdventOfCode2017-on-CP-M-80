MODULE Day18;
FROM SYSTEM IMPORT TSIZE;
IMPORT Texts,Strings,Processes,Queues;

TYPE Number = LONGREAL;

CONST N = 41;
      QSIZE = 256;
      ZERO = 0.0D0;

TYPE Opcode = (snd, set, add, mul, mod, rcv, jgz, jmp);
     Instruction =
       RECORD
         op : Opcode;
         reg, reg2 : CHAR;
         imm : BOOLEAN;
         operand : LONGINT;
         operand2 : Number;
       END;

VAR instr     : ARRAY [0..N-1] OF Instruction;
    queue     : ARRAY [0..1] OF Queues.Queue;
    processId : CARDINAL;
    last      : Number;

PROCEDURE parsefile(filename : ARRAY OF CHAR);
EXCEPTION FileNotFound,UnknownMnemonic;
VAR input :Texts.TEXT;
    pc : CARDINAL;
    string : Strings.String;
    value : LONGINT;
BEGIN
  IF NOT Texts.OpenText(input,filename) THEN RAISE FileNotFound END;
  FOR pc:=0 TO N-1 DO
    WITH instr[pc] DO
      Texts.ReadString(input,string);
      IF    string='snd' THEN op:=snd
      ELSIF string='set' THEN op:=set
      ELSIF string='add' THEN op:=add
      ELSIF string='mul' THEN op:=mul
      ELSIF string='mod' THEN op:=mod
      ELSIF string='rcv' THEN op:=rcv
      ELSIF string='jgz' THEN op:=jgz
      ELSE RAISE UnknownMnemonic
      END;
      Texts.ReadString(input,string);
      reg := string[0];
      IF reg < 'a' THEN
        IF op=jgz THEN op:=jmp ELSE RAISE UnknownMnemonic END;
      END;
      IF (op <> rcv) AND (op <> snd) THEN
        Texts.ReadChar(input,reg2);
        imm := reg2 < 'a';
        IF imm THEN
          Texts.ReadAgain(input);
          Texts.ReadLong(input,operand);
          operand2 := DOUBLE(operand);
        ELSE Texts.ReadLine(input,string)
        END;
      END;
    END
  END
END parsefile;

PROCEDURE run;
VAR value, lastData : Number;
    regs : ARRAY ['a'..'z'] OF Number;
    reg : CHAR;
    PC : INTEGER;
    thisId : CARDINAL;
BEGIN
  FOR reg:='a' TO 'z' DO regs[reg]:=ZERO END;
  thisId := processId;
  regs['p']:= DOUBLE(processId);

  PC := 0;
  LOOP
    WITH instr[PC] DO
      IF imm THEN value:=operand2 ELSE value:=regs[reg2] END;
      CASE op OF
      | snd : Queues.Enqueue(queue[thisId],regs[reg])
      | set : regs[reg] := value
      | add : regs[reg] := regs[reg] + value
      | mul : regs[reg] := regs[reg] * value
      | mod : regs[reg] := regs[reg] - value * DOUBLE( LONG(regs[reg]/value) )
      | rcv : Queues.Dequeue(queue[1-thisId],regs[reg])
      | jgz : IF regs[reg] > ZERO THEN PC := PC + INT(value) - 1 END
      | jmp : PC := PC + INT(value) - 1
      END
    END;
    INC(PC)
  END
END run;


BEGIN
  parsefile('DAY18.TXT');

  queue[0] := Queues.New(QSIZE,TSIZE(Number));
  queue[1] := Queues.New(QSIZE,TSIZE(Number));

  processId := 0;
  Processes.StartProcess(run,2048);
  Queues.Last(queue[0], last);
  WRITELN('Last value sent by proc #0 : ',CARD(last));

  processId := 1;
  run;
EXCEPTION
  Processes.DeadLock :
    WRITELN(Queues.Count(queue[1]),' values sent by proc #1')
END Day18.
