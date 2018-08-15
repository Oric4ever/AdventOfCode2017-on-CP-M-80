MODULE Day18;
(*
  Day #18: another most loved day...
  Modula-2 shines here: coroutines are part of the language definition,
  and Turbo Modula-2's Processes module defines Signals for co-routines synchronization.
  So I wrote a small Queues module to implement FIFO communication queues, and  
  the implementation becomes very elegant IMHO.

  (* well, except the fact I had to resort to double-precision floating point
  because the computations require bigger than 32-bit integer values. And I also
  would have liked a cleaner way to give the process id to the processes... *)

  Here is how the two processes cooperate to deliver the expected results:
  - the main process starts a new process (with process id #0), which will do its
  computations (including sending a number of values to a communication queue).
  As no other process is waiting for the communication queue, this process with id #0
  will continue to run...
  - ... until it reaches a first 'receive' instruction: process #0 will now be blocked,
  waiting for its receiving FIFO queue. So the first process (main process) will resume
  execution now. We can write the answer for part #1 now. 
  - Now this main process will start to run the same code, but with process id #1. 
  So, process #1 runs code and can extract values from the FIFO queue filled by process #0.
  But as soon as process #1 sends a value to the queue process #0 is waiting for, process #0
  resumes execution (and process #1 is suspended)...
  - both processes continue to exchange values this way: a process will continue execution
  until it either sends a value to a queue the other process is waiting for, or until it
  tries to extract a value from an empty queue.
  - finally, when both processes are waiting for the other's queue, then a Deadlock is
  detected, and the exception handler write the answer for part #2
*)

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
  parsefile('DAY18.IN');

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
