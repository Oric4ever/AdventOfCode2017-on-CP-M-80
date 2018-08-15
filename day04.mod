MODULE Day04;
(*
  Day #4: nothing special here...
  Input is processed one line at a time from floppy file...
*)
IMPORT Strings,Texts;
CONST N=512;
VAR line : Strings.String;
    input : Texts.TEXT;
    word : ARRAY [0..80] OF Strings.String;
    n, i, j, words, valids1, valids2 : CARDINAL;
    separator : CHAR;
    valid1, valid2 : BOOLEAN;
EXCEPTION FileNotFound;

PROCEDURE areAnagrams(w1,w2 : ARRAY OF CHAR) : BOOLEAN;
VAR length,i,j:CARDINAL;
    c : CHAR;
BEGIN
  length := Strings.Length(w1);
  IF Strings.Length(w2)<>length THEN RETURN FALSE END;
  FOR i:=0 TO length-1 DO
    c := w1[i];
    j := 0; WHILE (j<length) AND (w2[j]<>c) DO INC(j) END;
    IF j=length THEN RETURN FALSE END;
    w2[j] := '*';
  END;
  RETURN TRUE;
END areAnagrams;

BEGIN
  IF NOT Texts.OpenText(input,"DAY04.IN") THEN RAISE FileNotFound END;
  valids1 := 0; valids2 := 0;
  FOR n:=1 TO N DO
    words:=0;
    REPEAT INC(words); Texts.ReadString(input,word[words]); UNTIL Texts.EOLN(input);
    valid1 := TRUE; valid2 := TRUE;
    FOR i:=1 TO words DO
      FOR j:=i+1 TO words DO
        IF word[i]=word[j] THEN valid1:=FALSE END;
        IF areAnagrams(word[i],word[j]) THEN valid2:=FALSE END;
      END;
    END;
    IF valid1 THEN INC(valids1) END;
    IF valid2 THEN INC(valids2) END;
  END;
  Texts.CloseText(input);
  WRITELN(valids1,' without identical words');
  WRITELN(valids2,' without anagrams');
END Day04.

