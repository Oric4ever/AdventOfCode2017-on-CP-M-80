MODULE Day12;
IMPORT Texts;
FROM SYSTEM IMPORT ADDRESS,TSIZE;
FROM STORAGE IMPORT ALLOCATE,FREEMEM;
CONST N = 2000;
TYPE Connections = ARRAY [0..9] OF CARDINAL;
VAR table : ARRAY [0..N-1] OF POINTER TO Connections;
    nbConn : ARRAY [0..N-1] OF CARDINAL;
    marked : ARRAY [0..N-1] OF BOOLEAN;
    input : Texts.TEXT;
    dummy : ARRAY [0..5] OF CHAR;
    connections : Connections;
    i,n,nb,nbGroups,first,count : CARDINAL;

PROCEDURE Mark(prog : CARDINAL);
VAR i : CARDINAL;
BEGIN
  IF marked[prog] THEN RETURN END;
  marked[prog] := TRUE;
  FOR i:=0 TO nbConn[prog]-1 DO
    Mark(table[prog]^[i])
  END
END Mark;


EXCEPTION FileNotFound,ArrayTooSmall;
BEGIN
  IF NOT Texts.OpenText(input,"DAY12.TXT") THEN RAISE FileNotFound, "DAY12.TXT" END;
  FOR i:=0 TO N-1 DO
    Texts.ReadCard(input,n);
    Texts.ReadString(input,dummy);
    nb := 0;
    WHILE NOT Texts.EOLN(input) DO
      IF nb > HIGH(connections) THEN RAISE ArrayTooSmall END;
      Texts.ReadCard(input,connections[nb]);
      INC(nb);
    END;
    marked[i] := FALSE;
    nbConn[i] := nb;
    IF nb > 0 THEN
      ALLOCATE(table[i],2*nb);
      FOR n:=0 TO nb-1 DO table[i]^[n]:=connections[n] END;
    END;
  END;
  Texts.CloseText(input);

  nbGroups := 0;
  REPEAT
    INC(nbGroups);
    first:=0;
    WHILE marked[first] DO INC(first) END;
    Mark(first);
    count:=0;
    FOR i:=0 TO N-1 DO
      IF marked[i] THEN INC(count) END
    END;
    IF nbGroups=1 THEN WRITELN(count,' in group 0') END;
  UNTIL count=N;
  WRITELN(nbGroups,' groups');
END Day12.