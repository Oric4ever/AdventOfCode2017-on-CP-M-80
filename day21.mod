MODULE Day21;
(*
  Day #21: a painful day... 
  On a modern PC I had used 43 MB of memory to store the different matrices...
  Here I only use ~ 8 KB for the variables, but at the expense of a  greater 
  complexity due to several indirections... 
  At some point, I became confused with the different indirections levels,
  and so I decided to define some new type names for the different indices,
  and have the range check option activated...
*)

FROM Texts IMPORT TEXT, OpenText, CloseText, ReadString, ReadLine;
FROM Strings IMPORT String, Pos;

CONST NbRules2x2 = 6;
      NbRules3x3 = 102;

TYPE Pattern         = ARRAY [0..18] OF CHAR;
     Rotations       = ARRAY [0..7]  OF Pattern;
     Rule2x2index    = [1 .. NbRules2x2];
     Rule3x3index    = [1 .. NbRules3x3];
     Pattern2x2index = [0 .. 15];
     Pattern3x3index = [0 .. 511];
     Matrix4x4       = ARRAY [0..1],[0..1] OF Pattern2x2index;
     Matrix6x6       = ARRAY [0..1],[0..1] OF Pattern3x3index;
     Matrix9x9       = ARRAY [0..2],[0..2] OF Pattern3x3index;
     Rule3x3         = RECORD
                         step4x4 : Matrix4x4;
                         step6x6 : Matrix6x6;
                         step9x9 : Matrix9x9;
                         pixels4x4, pixels6x6 : CARDINAL;
                       END;

VAR rules2x2      : ARRAY Rule2x2index    OF Pattern3x3index;
    rules3x3      : ARRAY Rule3x3index    OF Rule3x3;
    rule2x2number : ARRAY Pattern2x2index OF Rule2x2index;
    rule3x3number : ARRAY Pattern3x3index OF Rule3x3index;
    nbPixels      : ARRAY Pattern3x3index OF CARDINAL;
    stats         : ARRAY Pattern3x3index OF LONGINT;

PROCEDURE Encode(pattern : ARRAY OF CHAR) : CARDINAL;
VAR size, x, y, index : CARDINAL;
    code : BITSET;
BEGIN
  size := Pos('/',pattern);
  code := BITSET{};
  FOR y:=0 TO size-1 DO
    FOR x:=0 TO size-1 DO
      index := y * (size+1) + x;
      IF pattern[index]='#' THEN code := code + BITSET{ y*size + x } END
    END
  END;
  RETURN CARDINAL(code);
END Encode;

PROCEDURE InitNbPixels;
VAR n, bit : CARDINAL;
    set : BITSET;
BEGIN
  FOR n:=0 TO HIGH(nbPixels) DO
    nbPixels[n] := 0;
    set := BITSET(n);
    FOR bit:=0 TO 8 DO
      IF bit IN set THEN INC(nbPixels[n]) END
    END
  END
END InitNbPixels;

PROCEDURE Rotate90(pattern : ARRAY OF CHAR; VAR rotated : ARRAY OF CHAR);
VAR size, x, y, index, toIndex : CARDINAL;
BEGIN
  size := Pos('/',pattern);
  rotated := pattern;
  FOR y:=0 TO size-1 DO
    FOR x:=0 TO size-1 DO
      index  := y * (size+1) + x;
      toIndex := x * (size+1) + size-1-y;
      rotated[toIndex] := pattern[index];
    END
  END
END Rotate90;

PROCEDURE Flip(pattern : ARRAY OF CHAR; VAR flipped : ARRAY OF CHAR);
VAR size, x, y : CARDINAL;
BEGIN
  size := Pos('/',pattern);
  flipped := pattern;
  FOR y:=0 TO size-1 DO
    FOR x:=0 TO size-1 DO
      flipped[x*(size+1)+y] := pattern[y*(size+1)+x]
    END
  END
END Flip;

PROCEDURE CalculateRotations(pattern : Pattern; VAR patterns : Rotations);
VAR n : CARDINAL;
BEGIN
  patterns[0] := pattern;
  FOR n:=1 TO 3 DO Rotate90(patterns[n-1], patterns[n]) END;
  FOR n:=0 TO 3 DO Flip(patterns[n], patterns[n+4]) END;
END CalculateRotations;

PROCEDURE Split4x4in4(pattern4x4 : ARRAY OF CHAR; VAR mat : Matrix4x4);
VAR pattern2x2 : ARRAY [0..4] OF CHAR;
    i, indexStart, x, y : CARDINAL;
BEGIN
  FOR y:=0 TO 1 DO
    FOR x:=0 TO 1 DO
      indexStart := y*10 + x*2;
      pattern2x2[0] := pattern4x4[indexStart + 0];
      pattern2x2[1] := pattern4x4[indexStart + 1];
      pattern2x2[2] := '/';
      pattern2x2[3] := pattern4x4[indexStart + 5];
      pattern2x2[4] := pattern4x4[indexStart + 6];
      mat[y][x] := Encode(pattern2x2);
    END;
  END;
END Split4x4in4;

PROCEDURE TransformMatrix4x4(mat : Matrix4x4; VAR result : Matrix6x6);
VAR x,y : CARDINAL;
BEGIN
  FOR y:=0 TO 1 DO
    FOR x:=0 TO 1 DO
      result[y][x] := rules2x2[ rule2x2number[ mat[y][x] ] ]
    END
  END
END TransformMatrix4x4;

PROCEDURE Transform6x6in9(mat : Matrix6x6; VAR result : Matrix9x9);
VAR matrix : ARRAY [0..5],[0..5] OF CHAR;
    setOf9bits, setOf4bits : BITSET;
    i,j,x,y : CARDINAL;
BEGIN
  FOR y:=0 TO 1 DO
    FOR x:=0 TO 1 DO
      setOf9bits := BITSET( mat[y][x] );
      FOR j:=0 TO 2 DO
        FOR i:=0 TO 2 DO
          IF j*3+i IN setOf9bits
          THEN matrix[y*3+j][x*3+i] := '#'
          ELSE matrix[y*3+j][x*3+i] := '.'
          END
        END
      END
    END
  END;
  FOR y:=0 TO 2 DO
    FOR x:=0 TO 2 DO
      setOf4bits := BITSET{};
      IF matrix[y*2+0][x*2+0]='#' THEN setOf4bits := setOf4bits + BITSET{0} END;
      IF matrix[y*2+0][x*2+1]='#' THEN setOf4bits := setOf4bits + BITSET{1} END;
      IF matrix[y*2+1][x*2+0]='#' THEN setOf4bits := setOf4bits + BITSET{2} END;
      IF matrix[y*2+1][x*2+1]='#' THEN setOf4bits := setOf4bits + BITSET{3} END;
      result[y][x] := rules2x2[ rule2x2number[ Rule2x2index( setOf4bits ) ] ];
    END;
  END;
END Transform6x6in9;

PROCEDURE InitRules(filename: ARRAY OF CHAR);
VAR in : TEXT;
    n, i, j : CARDINAL;
    pattern1, pattern2 : Pattern;
    patterns : Rotations;
    dummy : String;
EXCEPTION FileNotFound;
BEGIN
  IF NOT OpenText(in,"DAY21.IN") THEN RAISE FileNotFound END;
  FOR n:=1 TO NbRules2x2 DO
    ReadString(in, pattern1);  ReadString(in, dummy);  ReadString(in, pattern2);
    rules2x2[n] := Encode(pattern2);
    CalculateRotations(pattern1, patterns);
    FOR i:=0 TO 7 DO rule2x2number[ Encode(patterns[i]) ] := n END
  END;
  FOR n:=1 TO NbRules3x3 DO
    ReadString(in, pattern1);  ReadString(in, dummy);  ReadString(in, pattern2);
    Split4x4in4(pattern2, rules3x3[n].step4x4);
    CalculateRotations(pattern1, patterns);
    FOR i:=0 TO 7 DO rule3x3number[ Encode(patterns[i]) ] := n END
  END;
  CloseText(in);

  InitNbPixels;
  FOR n:=1 TO NbRules3x3 DO
    WITH rules3x3[n] DO
      TransformMatrix4x4(step4x4, step6x6);
      Transform6x6in9(step6x6, step9x9);
      pixels4x4 := 0; pixels6x6 := 0;
      FOR j:=0 TO 1 DO
        FOR i:=0 TO 1 DO
          INC(pixels4x4, nbPixels[step4x4[j][i]]);
          INC(pixels6x6, nbPixels[step6x6[j][i]]);
        END
      END
    END
  END
END InitRules;

PROCEDURE Do3Transformations(statsBefore : ARRAY OF LONGINT; VAR statsAfter : ARRAY OF LONGINT);
VAR index, i, j, n : CARDINAL;
    ruleNum : Rule3x3index;
BEGIN
  FOR n:=0 TO HIGH(statsAfter) DO statsAfter[n] := 0L END;
  FOR n:=0 TO HIGH(statsBefore) DO
    ruleNum := rule3x3number[n];
    WITH rules3x3[ruleNum] DO
      FOR j:=0 TO 2 DO
        FOR i:=0 TO 2 DO
          index := step9x9[j][i];
          statsAfter[index] := statsAfter[index] + statsBefore[n]
        END
      END
    END
  END
END Do3Transformations;

PROCEDURE CountPixels(startPattern, nbTransforms : CARDINAL) : LONGINT;
VAR i, n, ruleNum, subPixels, remainder : CARDINAL;
    pixels : LONGINT;
BEGIN
  FOR i:=0 TO HIGH(stats) DO stats[i]:=0L END;
  stats[startPattern] := 1L;

  FOR i:=1 TO nbTransforms DIV 3 DO Do3Transformations(stats,stats) END;

  pixels := 0L; remainder := nbTransforms MOD 3;
  FOR n:=0 TO HIGH(stats) DO
    ruleNum := rule3x3number[n];
    CASE remainder OF
    | 0 : subPixels := nbPixels[n]
    | 1 : subPixels := rules3x3[ruleNum].pixels4x4
    | 2 : subPixels := rules3x3[ruleNum].pixels6x6
    END;
    pixels := pixels + LONG(subPixels) * stats[n]
  END;
  RETURN pixels
END CountPixels;

VAR start : Pattern3x3index;
    pixels : LONGINT;
BEGIN
  InitRules("DAY21.IN");
  start := Encode(".#./..#/###");
  WRITELN('After 5 iterations :',CountPixels(start,5), ' pixels');
  WRITELN('After 18 iterations:',CountPixels(start,18),' pixels');
END Day21.
