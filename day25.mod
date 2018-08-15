MODULE Day25;
CONST STEPS = 12173597L;
      Size = 10000;
TYPE STATE = (A,B,C,D,E,F);
VAR tape : ARRAY [-Size..+Size] OF BOOLEAN;
    i, pos : INTEGER;
    n, count : CARDINAL;
    state : STATE;

PROCEDURE Steps(count : CARDINAL);
VAR n : CARDINAL;
BEGIN
 FOR n:=1 TO count DO
  IF tape[pos] THEN
    CASE state OF
    | A : tape[pos]:=FALSE; pos:=pos-1; state:=C
    | B : tape[pos]:=TRUE ; pos:=pos+1; state:=D
    | C : tape[pos]:=FALSE; pos:=pos-1; state:=E
    | D : tape[pos]:=FALSE; pos:=pos+1; state:=B
    | E : tape[pos]:=TRUE ; pos:=pos-1; state:=C
    | F : tape[pos]:=TRUE ; pos:=pos+1; state:=A
    END
  ELSE
    CASE state OF
    | A : tape[pos]:=TRUE ; pos:=pos+1; state:=B
    | B : tape[pos]:=TRUE ; pos:=pos-1; state:=A
    | C : tape[pos]:=TRUE ; pos:=pos+1; state:=A
    | D : tape[pos]:=TRUE ; pos:=pos+1; state:=A
    | E : tape[pos]:=TRUE ; pos:=pos-1; state:=F
    | F : tape[pos]:=TRUE ; pos:=pos+1; state:=D
    END
  END
 END
END Steps;

BEGIN
  pos:=0; state:=A;
  FOR n:=1 TO CARD(STEPS DIV 10000L) DO Steps(10000) END;
  Steps( CARD(STEPS MOD 10000L) );

  FOR i:=-Size TO +Size DO
    IF tape[i] THEN INC(count) END;
  END;
  WRITELN('count : ',count);
END Day25.