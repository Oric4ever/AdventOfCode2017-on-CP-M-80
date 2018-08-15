MODULE Day07;
IMPORT Texts,Strings;
CONST N=1098;
TYPE Cell = RECORD
              name : ARRAY [0..7] OF CHAR;
              weight : LONGINT;
              nbSons : CARDINAL;
              sons : ARRAY [1..7] OF CARDINAL;
            END;
VAR cells : ARRAY [1..N] OF Cell;
    node : CARDINAL;

PROCEDURE FindName(name : ARRAY OF CHAR) : CARDINAL;
VAR i : CARDINAL;
EXCEPTION NameNotFound;
BEGIN
  FOR i:=1 TO N DO
    IF name=cells[i].name THEN RETURN i END;
  END;
  RAISE NameNotFound;
END FindName;

PROCEDURE Parent(node : CARDINAL) : CARDINAL;
VAR i, n : CARDINAL;
BEGIN
  FOR i:=1 TO N DO
    FOR n:=1 TO cells[i].nbSons DO
      IF cells[i].sons[n]=node THEN RETURN i END;
    END;
  END;
  RETURN 0;
END Parent;

PROCEDURE Weight(node : CARDINAL) : LONGINT;
VAR i : CARDINAL;
    sum : LONGINT;
BEGIN
  sum := cells[node].weight;
  FOR i:=1 TO cells[node].nbSons DO
    sum := sum + Weight(cells[node].sons[i]);
  END;
  RETURN sum;
END Weight;

PROCEDURE SearchUnbalanced(node : CARDINAL);
VAR i, j, nbSons, nbDiffs, son, brother : CARDINAL;
    weights : ARRAY [1..7] OF LONGINT;
BEGIN
  nbSons := cells[node].nbSons;
  IF nbSons <> 0 THEN
    FOR i:=1 TO nbSons DO weights[i]:=Weight(cells[node].sons[i]) END;
    FOR i:=1 TO nbSons DO
      nbDiffs := 0;
      FOR j:=1 TO nbSons DO
        IF weights[i] <> weights[j] THEN INC(nbDiffs) END
      END;
      IF nbDiffs > 1 THEN
        son := cells[node].sons[i];
        brother := 1;
        IF i=1 THEN brother:=2 END;
        WRITELN(cells[son].name,' is unbalanced, and weights ',weights[i],' instead of ',weights[brother]);
        SearchUnbalanced(son);
        RETURN
      END;
    END;
  END;
  WRITELN('All sons of ',cells[node].name,' are balanced, and its own weight is ',cells[node].weight);
END SearchUnbalanced;

PROCEDURE ReadData;
VAR n, length, nbSons : CARDINAL;
    input : Texts.TEXT;
    dummy : CHAR;
    name : ARRAY [0..7] OF CHAR;
EXCEPTION FileNotFound;
BEGIN
  IF NOT Texts.OpenText(input,"DAY07.TXT") THEN RAISE FileNotFound,"DAY07.TXT" END;
  FOR n:=1 TO N DO
    Texts.ReadString(input,cells[n].name);
    Texts.ReadLn(input);
  END;
  Texts.CloseText(input);

  IF NOT Texts.OpenText(input,"DAY07.TXT") THEN RAISE FileNotFound,"DAY07.TXT" END;
  FOR n:=1 TO N DO
    Texts.ReadString(input,name);
    Texts.ReadChar(input,dummy);  (* left parenthesis *)
    Texts.ReadLong(input,cells[n].weight); (* ReadLong reads right parenthesis and even next chars! *)
    nbSons := 0;
    IF NOT Texts.EOLN(input) THEN
      Texts.ReadString(input,name); (* '->' *)
      WHILE NOT Texts.EOLN(input) DO
        INC(nbSons);
        Texts.ReadString(input,name);
        length := Strings.Length(name);
        IF name[length-1]=',' THEN name[length-1]:=0C END;
        cells[n].sons[nbSons] := FindName(name);
      END;
    END;
    cells[n].nbSons := nbSons;
  END;
END ReadData;

BEGIN
  ReadData;
  node := 1;
  WHILE Parent(node)<>0 DO node:=Parent(node) END;
  WRITELN('Root : ',cells[node].name);
  SearchUnbalanced(node);
END Day07.