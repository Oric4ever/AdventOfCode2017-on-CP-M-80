MODULE Day11;
(* 
  Day #11: nothing special here...
*)
IMPORT Texts;
EXCEPTION FileNotFound;
VAR input : Texts.TEXT;
    x,y : INTEGER;
    distX, distY, dist, furthest : CARDINAL;
    dir : ARRAY [0..2] OF CHAR;
BEGIN
  x := 0; y := 0; furthest := 0;
  IF NOT Texts.OpenText(input,"DAY11.IN") THEN RAISE FileNotFound END;
  REPEAT
    Texts.ReadString(input,dir);

    IF    dir='n'  THEN y := y - 2
    ELSIF dir='s'  THEN y := y + 2
    ELSIF dir='ne' THEN INC(x); DEC(y)
    ELSIF dir='nw' THEN DEC(x); DEC(y)
    ELSIF dir='se' THEN INC(x); INC(y)
    ELSIF dir='sw' THEN DEC(x); INC(y)
    END;

    distX := ABS(x); distY := ABS(y);
    IF distX > distY THEN dist:=distX ELSE dist:=distY END;
    IF dist > furthest THEN furthest:=dist END;
  UNTIL Texts.EOT(input);

  WRITELN('Final dist = ',dist);
  WRITELN('Furthest dist = ',furthest);
END Day11.
