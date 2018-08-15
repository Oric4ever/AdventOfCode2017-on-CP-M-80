MODULE Day17;
(*
  Day #17: argh, had to ressort to optimized Z80 assembly code for a reasonnable execution time...
*)
FROM SYSTEM IMPORT CODE;

PROCEDURE Part2() : LONGINT;
CODE("DAY17ASM");
END Part2;

BEGIN
  WRITELN(Part2());
END Day17.
