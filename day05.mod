MODULE Day05;
(*
  Day #5: nothing special here...
  Input is read twice (once for each part) from floppy file, although I could have used two arrays...
  I used my small Input module to separate the parsing work.
*)
FROM Input IMPORT ReadIntegerInput;
CONST size=1033;
VAR disp : ARRAY [0..size-1] OF INTEGER;
    pos, d : INTEGER;
    i : CARDINAL;
    steps : LONGINT;
BEGIN
  ReadIntegerInput("DAY05.IN",disp,size);
  pos:=0; steps:=0L;
  WHILE (pos >= 0) AND (pos < size) DO
    d := disp[pos];
    INC(disp[pos]);
    pos := pos + d;
    steps := steps + 1L;
  END;
  WRITELN("First rules : ",steps," steps");
  
  ReadIntegerInput("DAY05.IN",disp,size);
  pos:=0; steps:=0L;
  WHILE (pos >= 0) AND (pos < size) DO
    d := disp[pos];
    IF d>=3 THEN DEC(disp[pos]) ELSE INC(disp[pos]) END;
    pos := pos + d;
    steps := steps + 1L;
  END;
  WRITELN("New rules : ",steps," steps");
END Day05.
      
  
