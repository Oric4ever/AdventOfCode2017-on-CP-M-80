MODULE Day19;
IMPORT Texts,Strings;
CONST Size = 201;
VAR map : ARRAY [1..Size] OF ARRAY [0..Size] OF CHAR;
    path : Strings.String;
    i, steps, pathSize : CARDINAL;
    input : Texts.TEXT;
    x, y, dx, dy, tmp : INTEGER;



EXCEPTION FileNotFound;
BEGIN
  IF NOT Texts.OpenText(input,"DAY19.TXT") THEN RAISE FileNotFound,"DAY19.TXT" END;
  FOR i:=1 TO Size DO Texts.ReadLine(input,map[i]) END;
  Texts.CloseText(input);


  y:=1; x:=0; WHILE map[y][x] <> '|' DO INC(x) END;
  WRITELN('start from x=',x);

  dx:=0; dy:=+1;
  steps:=0; pathSize:=0;
  WHILE map[y][x]#' ' DO
    INC(steps);
    IF map[y][x]='+' THEN
      tmp := dx; dx := dy; dy := tmp;
      IF map[y+dy][x+dx]=' ' THEN dx := -dx; dy := -dy END;
    ELSIF (map[y][x]>='A') AND (map[y][x]<='Z') THEN
      path[pathSize]:=map[y][x];
      INC(pathSize)
    END;
    x := x + dx; y := y + dy;
  END;
  path[pathSize]:=0C;

  WRITELN('Path : ',path);
  WRITELN('Steps : ',steps);
END Day19.