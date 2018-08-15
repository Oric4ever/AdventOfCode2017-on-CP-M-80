MODULE Day03;
CONST target = 368078L;
      size = 10;
VAR x, y, dx, dy, limit : INTEGER;

PROCEDURE SpiralMove(VAR x,y,dx,dy,limit : INTEGER);
BEGIN
  IF  (x=limit) AND (y=limit) THEN INC(limit);
  ELSIF (x=-limit) AND (dx<0) THEN dx:=0; dy:=-1;
  ELSIF (y=-limit) AND (dy<0) THEN dy:=0; dx:=+1;
  ELSIF (x=+limit) AND (dx>0) THEN dx:=0; dy:=+1;
  ELSIF (y=+limit) AND (dy>0) THEN dy:=0; dx:=-1;
  END;
  x := x + dx; y := y + dy;
END SpiralMove;

PROCEDURE Part1;
VAR n : LONGINT;
BEGIN
  x := 0; y := 0; limit := 0; dx := 0; dy := +1;
  n := 1L;
  WHILE n<target DO
    SpiralMove(x,y,dx,dy,limit);
    n := n + 1L;
  END;
  WRITELN("Distance of ",target," : ",ABS(x)+ABS(y));
END Part1;


PROCEDURE Part2;
VAR spiral : ARRAY [-size..+size] OF ARRAY [-size..+size] OF LONGINT;

  PROCEDURE NeighborSum(x,y : INTEGER) : LONGINT;
  VAR sum : LONGINT;
      i, j : INTEGER;
  BEGIN
    sum := 0L;
    FOR i:=x-1 TO x+1 DO
      FOR j:=y-1 TO y+1 DO
        sum := sum + spiral[i][j];
      END;
    END;
    RETURN sum;
  END NeighborSum;

BEGIN
  FOR x:=-size TO +size DO FOR y:=-size TO +size DO spiral[x][y]:=0L END END;
  x := 0; y := 0; limit := 0; dx := 0; dy := +1;
  spiral[x][y] := 1L;
  REPEAT
    SpiralMove(x,y,dx,dy,limit);
    spiral[x][y] := NeighborSum(x,y);
  UNTIL spiral[x][y] >= target;
  WRITELN("First value > target : ",spiral[x][y]);
END Part2;

BEGIN
  Part1;
  Part2;
END Day03.