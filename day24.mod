MODULE Day24;
IMPORT Texts,Strings,Convert;
CONST N = 57;
TYPE Domino = RECORD a,b : CARDINAL END;
VAR domino : ARRAY [1..N] OF Domino;

(*
 (* Natural recursive definition too slow due to cost of function invocation *)

PROCEDURE Strongest(from, currSum, currLength : CARDINAL) : CARDINAL;
VAR max, i, next, big : CARDINAL;
BEGIN
  max := currSum;
  FOR i:=1 TO N DO
    WITH dominoes[i] DO
      IF NOT used AND ((from=a) OR (from=b)) THEN
        from := a + b - from;
        used := TRUE;
        big := Strongest(next, currSum + a + b);
        used := FALSE;
        IF big > max THEN max := big END
      END
    END
  END;
  RETURN max;
END Strongest;

*)

PROCEDURE FindBoth; (* much faster iterative definition *)
VAR i, length, from, sum, max1, max2, longest : CARDINAL;
    dom : Domino;
    chain : ARRAY [1..N] OF CARDINAL;
BEGIN
  max1 := 0;  max2 := 0;  longest := 0;  sum := 0;  from := 0;
  length := 0;  i := 1;
  LOOP
    WHILE (i<=N) AND (domino[i].a<>from) AND (domino[i].b<>from) DO
      INC(i)
    END;
    IF i<=N THEN
      INC(length);
      chain[length] := i;
      dom := domino[i];  domino[i] := domino[length];  domino[length]:=dom;
      WITH dom DO INC(sum, a+b); from := a+b - from END;
      i := length + 1;
    ELSIF length > 0 THEN
      IF sum > max1 THEN max1 := sum END;
      IF (length > longest) OR (length = longest) AND (sum > max2) THEN
        longest := length;
        max2 := sum;
      END;
      dom := domino[length];
      WITH dom DO DEC(sum, a+b); from := a+b - from END;
      i := chain[length];
      domino[length]:=domino[i]; domino[i]:=dom;
      DEC(length);
      INC(i);
    ELSE
      EXIT
    END (* IF *);
  END; (* LOOP *)
  WRITELN('Strongest chain: ',max1);
  WRITELN('Strongest longest chain: ',max2);
END FindBoth;

EXCEPTION FileNotFound, BadFormat;
VAR input : Texts.TEXT;
    i, length, pos : CARDINAL;
    line, str : Strings.String;
    res : BOOLEAN;
BEGIN
  IF NOT Texts.OpenText(input,"DAY24.TXT") THEN RAISE FileNotFound END;
  FOR i:=1 TO N DO
    WITH domino[i] DO
      Texts.ReadLine(input,line);
      length := Strings.Length(line);
      pos := Strings.Pos("/",line);
      Strings.Copy(line,0,pos,str);
      IF NOT Convert.StrToCard(str,a) THEN RAISE BadFormat END;
      Strings.Copy(line,pos+1,length-pos,str);
      IF NOT Convert.StrToCard(str,b) THEN RAISE BadFormat END;
    END;
  END;

  FindBoth;
END Day24.