MODULE Day14;
(*
  Day #14: follow-up of Day #10
  - should rewrite the manual conversion by using the Converts module
*)
IMPORT KnotHash, Strings;

VAR key : Strings.String;
    map : ARRAY [0..127] OF KnotHash.HASH;

PROCEDURE IsSet(row, col : CARDINAL) : BOOLEAN;
BEGIN
  RETURN (7 - col MOD 8) IN map[row][col DIV 8];
END IsSet;

PROCEDURE Unset(row,col : CARDINAL);
BEGIN
  map[row][col DIV 8] := map[row][col DIV 8] - BITSET{ 7 - col MOD 8 };
END Unset;

PROCEDURE Clear(row, col : CARDINAL);
BEGIN
  IF IsSet(row,col) THEN
    Unset(row,col);
    IF row > 0   THEN Clear(row-1,col) END;
    IF row < 127 THEN Clear(row+1,col) END;
    IF col > 0   THEN Clear(row,col-1) END;
    IF col < 127 THEN Clear(row,col+1) END;
  END;
END Clear;

VAR row,col,keyLen,used,nbRegions : CARDINAL;
BEGIN
  FOR row:=0 TO 127 DO
    key := 'ugkiagan-';
    keyLen := Strings.Length(key);
    IF row > 99 THEN key[keyLen]:='1'; INC(keyLen) END;
    IF row > 9  THEN key[keyLen]:=CHR(48 + ((row DIV 10) MOD 10)); INC(keyLen) END;
    key[keyLen]:=CHR(48 + row MOD 10);
    key[keyLen+1]:=0C;

    KnotHash.Knot(key,map[row]);
    FOR col:=0 TO 127 DO
      IF IsSet(row,col) THEN INC(used) END;
    END;
  END;
  WRITELN('nb used : ',used);

  nbRegions := 0;
  FOR row:=0 TO 127 DO
    FOR col:=0 TO 127 DO
      IF IsSet(row,col) THEN
        INC(nbRegions);
        Clear(row,col)
      END;
    END;
  END;
  WRITELN(nbRegions,' regions');
END Day14.
