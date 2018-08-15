IMPLEMENTATION MODULE KnotHash;
FROM SYSTEM IMPORT WORD;
IMPORT Strings,InOut;

CONST Size = 256;

PROCEDURE ReversePart(VAR list : ARRAY OF WORD; start, size : CARDINAL);
VAR end : CARDINAL;
    tmp : WORD;
BEGIN
  end := start + size - 1;
  WHILE start < end DO
    tmp := list[start MOD Size];
    list[start MOD Size] := list[end MOD Size];
    list[end MOD Size] := tmp;
    INC(start); DEC(end);
  END;
END ReversePart;

PROCEDURE ComputeHash(VAR list : ARRAY OF BITSET; VAR hash : HASH);
VAR block,i: CARDINAL;
    xorSum : BITSET;
BEGIN
  FOR block:=0 TO 15 DO
    xorSum := BITSET{};
    FOR i:=0 TO 15 DO
      xorSum := xorSum / list[block*16+i]; (* / is XOR *)
    END;
    hash[block] := xorSum;
  END;
END ComputeHash;

VAR list : ARRAY [0..Size-1] OF BITSET;

PROCEDURE Knot(VAR input : ARRAY OF CHAR; VAR hash : HASH);
VAR len,i,rounds,size,start,skip : CARDINAL;
BEGIN
  len := Strings.Length(input);
  input[len+0] := CHR(17);
  input[len+1] := CHR(31);
  input[len+2] := CHR(73);
  input[len+3] := CHR(47);
  input[len+4] := CHR(23);
  input[len+5] :=  0C;
  INC(len,5);

  FOR i:=0 TO Size-1 DO list[i] := BITSET(i) END;
  start := 0; skip := 0;
  FOR rounds:=1 TO 64 DO
    FOR i:=0 TO len-1 DO
      size := ORD(input[i]);
      ReversePart(list, start, size);
      start := (start + size + skip) MOD Size;
      INC(skip);
    END;
  END;

  ComputeHash(list,hash);
END Knot;

PROCEDURE HexChar(n : CARDINAL) : CHAR;
BEGIN
  IF n < 10 THEN RETURN CHR(48+n) ELSE RETURN CHR(87+n) END
END HexChar;

PROCEDURE WriteHash(VAR hash : HASH);
VAR i,hex : CARDINAL;
BEGIN
  FOR i:=0 TO HIGH(hash) DO
    hex := CARDINAL(hash[i]);
    WRITE(HexChar(hex DIV 16));
    WRITE(HexChar(hex MOD 16));
  END;
  WRITELN;
END WriteHash;

END KnotHash.