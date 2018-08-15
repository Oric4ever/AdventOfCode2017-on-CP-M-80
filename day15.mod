MODULE Day15;
CONST MAXLONG = 2147483647.0D0;

VAR seedA : LONGINT;
PROCEDURE genA():LONGINT;
VAR tmp : LONGREAL;
BEGIN
  tmp := DOUBLE(seedA) * 16807.0D0;
  seedA := LONG(tmp - DOUBLE(LONG(tmp / MAXLONG)) * MAXLONG);
  RETURN seedA;
END genA;


VAR seedB : LONGINT;
PROCEDURE genB():LONGINT;
VAR tmp : LONGREAL;
BEGIN
  tmp := DOUBLE(seedB) * 48271.0D0;
  seedB := LONG(tmp - DOUBLE(LONG(tmp / MAXLONG)) * MAXLONG);
  RETURN seedB;
END genB;

VAR count, i, n : CARDINAL;
    a, b : LONGINT;
BEGIN
  seedA := 783L;  seedB := 325L;

  count := 0;
  FOR i:=1 TO 500 DO FOR n:=1 TO 1000 DO
    REPEAT a := genA() UNTIL a MOD 4L = 0L;
    REPEAT b := genB() UNTIL b MOD 8L = 0L;
    IF a MOD 65536L = b MOD 65536L THEN INC(count) END;
  END END;
  WRITELN(count)
END Day15.

