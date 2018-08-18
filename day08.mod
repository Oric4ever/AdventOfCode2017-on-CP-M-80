MODULE Day08;
(*
  Day #08: defining procedure types...
  Modula-2 has some limitations : cannot return a procedure value,
  but can assign a procedure value to a variable passed by reference...
*)
IMPORT Texts,Strings;
CONST N = 1000;
      Size = 12;
TYPE Op = PROCEDURE(CARDINAL,INTEGER);
     OpRel = PROCEDURE(CARDINAL,INTEGER):BOOLEAN;
     Reg =
       RECORD
         name : ARRAY [1..Size] OF CHAR;
         val  : INTEGER;
       END;
VAR regs : ARRAY [1..N] OF Reg;
    nbRegs : CARDINAL;

PROCEDURE findReg(name : ARRAY OF CHAR) : CARDINAL;
VAR i : CARDINAL;
BEGIN
  FOR i:=1 TO nbRegs DO
    IF name = regs[i].name THEN RETURN i END
  END;
  INC(nbRegs);
  regs[nbRegs].name := name;
  regs[nbRegs].val  := 0;
  RETURN nbRegs;
END findReg;

PROCEDURE lt(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val <  v END lt;
PROCEDURE gt(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val >  v END gt;
PROCEDURE eq(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val =  v END eq;
PROCEDURE ne(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val <> v END ne;
PROCEDURE ge(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val >= v END ge;
PROCEDURE le(r : CARDINAL; v : INTEGER) : BOOLEAN; BEGIN RETURN regs[r].val <= v END le;

PROCEDURE nameToRelation(name : ARRAY OF CHAR; VAR rel : OpRel);
EXCEPTION UnknownOperator;
BEGIN
     IF name='<'  THEN rel := lt
  ELSIF name='>'  THEN rel := gt
  ELSIF name="==" THEN rel := eq
  ELSIF name="!=" THEN rel := ne
  ELSIF name=">=" THEN rel := ge
  ELSIF name="<=" THEN rel := le
  ELSE RAISE UnknownOperator
  END
END nameToRelation;

PROCEDURE inc(r : CARDINAL; val : INTEGER); BEGIN regs[r].val := regs[r].val + val END inc;
PROCEDURE dec(r : CARDINAL; val : INTEGER); BEGIN regs[r].val := regs[r].val - val END dec;

PROCEDURE nameToOpcode(name : ARRAY OF CHAR; VAR opcode : Op);
BEGIN
  IF name="inc" THEN opcode := inc ELSE opcode := dec END
END nameToOpcode;

EXCEPTION FileNotFound;
VAR input : Texts.TEXT;
    name, oper, rel : Strings.String;
    i, r1, r2 : CARDINAL;
    cmpval, delta, maxEver, max : INTEGER;
    cmp : OpRel;
    opcode : Op;
BEGIN
  nbRegs := 0;
  maxEver := -32767;
  IF NOT Texts.OpenText(input,"DAY08.IN") THEN RAISE FileNotFound END;
  REPEAT
    Texts.ReadString(input,name);  r1 := findReg(name);
    Texts.ReadString(input,oper);  nameToOpcode(oper,opcode);
    Texts.ReadInt   (input,delta);
    Texts.ReadString(input,name);  (* if *)
    Texts.ReadString(input,name);  r2 := findReg(name);
    Texts.ReadString(input,rel);   nameToRelation(rel,cmp);
    Texts.ReadInt   (input,cmpval);
    WRITELN(regs[r1].name,' ',oper,' ',delta,' if ',regs[r2].name,' ',rel,' ',cmpval);

    IF cmp(r2,cmpval) THEN opcode(r1,delta) END;
    IF gt(r1,maxEver) THEN maxEver := regs[r1].val END;
  UNTIL Texts.EOT(input);
  Texts.CloseText(input);

  WRITELN; WRITELN("Largest value ever : ",maxEver);

  max := -32767;
  FOR i:=1 TO nbRegs DO
    IF regs[i].val > max THEN max := regs[i].val END
  END;
  WRITELN("Largest value at the end : ",max);
END Day08.
