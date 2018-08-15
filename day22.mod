MODULE Day22;
IMPORT Texts;
CONST N = 25;
      Lines = 400; Columns = 400;
      LineSize = Columns DIV 16;
      Size = Lines*LineSize;
TYPE Bitmap = ARRAY [0..Size-1] OF BITSET;
     Dir = (UP, LEFT, DOWN, RIGHT);

VAR map, map2 : Bitmap;
EXCEPTION XLowLimit, XHighLimit, YLowLimit, YHighLimit;

PROCEDURE ReadMap;
EXCEPTION FileNotFound;
VAR input : Texts.TEXT;
    x, index, i, j : CARDINAL;
    c : CHAR;
BEGIN
  FOR i:=0 TO Size-1 DO map[i] := BITSET{}; map2[i] := BITSET{};  END;

  IF NOT Texts.OpenText(input,"DAY22.TXT") THEN RAISE FileNotFound END;
  FOR j := N-1 TO 0 BY -1 DO
    FOR i := 0 TO N-1 DO
      x := i + Columns DIV 2;
      index := (j + Lines DIV 2) * LineSize + x DIV 16;
      Texts.ReadChar(input,c);
      IF c='#' THEN map[index]:=map[index] + BITSET{x MOD 16} ; map2[index] := map[index] END
    END;
    Texts.ReadChar(input,c); (* EOL *)
  END;
  Texts.CloseText(input);
END ReadMap;


PROCEDURE Part1;
VAR i, index, lineStart, x, offset, bit, infections : CARDINAL;
    dir : Dir;
BEGIN
  infections := 0;
  lineStart := ((Lines + N) DIV 2) * LineSize; x := (Columns + N) DIV 2;  dir := UP;
  FOR i:=1 TO 10000 DO
    offset := x DIV 16;  bit := x MOD 16;  index := lineStart + offset;
    IF bit IN map[index] THEN
      IF dir=UP THEN dir:=RIGHT ELSE DEC(dir) END;
    ELSE
      IF dir=RIGHT THEN dir:=UP ELSE INC(dir) END;
      INC(infections);
    END;
    map[index] := map[index] / BITSET{bit};
    CASE dir OF
    | UP    : INC(lineStart,LineSize);                        (*  IF lineStart=Size THEN RAISE YHighLimit END *)
    | LEFT  : (* IF x=0 THEN RAISE XHighLimit END; *)         DEC(x)
    | DOWN  : (* IF lineStart=0 THEN RAISE YLowLimit END; *)  DEC(lineStart,LineSize)
    | RIGHT : INC(x);                                         (* IF x=Columns THEN RAISE XHighLimit END *)
    END
  END;
  WRITELN('Part #1: ',infections,' infections.');
END Part1;

PROCEDURE Part2;
CONST EMPTY = BITSET{};
VAR dir : Dir;
    mask : BITSET;
    index, bit, n, i, lineStart, x, offset : CARDINAL;
    infections : LONGINT;
BEGIN
  infections := 0L;
  lineStart := ((Lines + N) DIV 2) * LineSize; x := (Columns + N) DIV 2;  dir := UP;
  offset := x DIV 16; bit := x MOD 16;  index := lineStart + offset;
  FOR n:=1 TO 1000 DO FOR i:=1 TO 10000 DO
    mask := BITSET{bit};
    IF map[index] * mask <> EMPTY THEN
      IF map2[index] * mask <> EMPTY THEN               (* 11 : # *)
        IF dir=UP THEN dir:=RIGHT ELSE DEC(dir) END;
        map[index] := map[index] - mask;                (* => 01=F *)
      ELSE                                              (* 10 : W *)
        infections := infections + 1L;
        map2[index] := map2[index] + mask;              (* => 11=# *)
      END;
    ELSE
      IF map2[index] * mask <> EMPTY THEN               (* 01 : F *)
        map2[index] := map2[index] - mask;              (* => 00=. *)
        INC(dir,2); IF dir>RIGHT THEN DEC(dir,4) END;
      ELSE                                              (* 00 : . *)
        map[index] := map[index] + mask;                (* => 10=W *)
        IF dir=RIGHT THEN dir:=UP ELSE INC(dir) END;
      END;
    END;
    CASE dir OF
    | UP    : INC(index,LineSize)
    | LEFT  : IF bit<>0 THEN DEC(bit) ELSE DEC(index) ; bit:=15 END
    | DOWN  : DEC(index,LineSize)
    | RIGHT : INC(bit); IF bit=16 THEN bit:=0 ; INC(index) END
    END
  END END;
  WRITELN('Part #2: ',infections,' infections.');
END Part2;

BEGIN
  ReadMap; Part1;
  ReadMap; Part2;
END Day22.

