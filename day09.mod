MODULE Day09;
(*
  Day #09 : nothing special
*)
FROM Texts IMPORT TEXT, ReadChar, OpenText, CloseText;
VAR input : TEXT;
    score, removed : CARDINAL;
    c : CHAR;

PROCEDURE readGarbage;
BEGIN
  ReadChar(input,c);
  WHILE c<>'>' DO
    IF c='!' THEN ReadChar(input,c) ELSE INC(removed) END;
    ReadChar(input,c);
  END
END readGarbage;

PROCEDURE readGroup(level : CARDINAL);
BEGIN
  ReadChar(input,c);
  WHILE c<>'}' DO
    CASE c OF
    | '{' : readGroup(level+1)
    | '<' : readGarbage
    END;
    ReadChar(input,c)
  END;
  INC(score,level)
END readGroup;

EXCEPTION FileNotFound;
BEGIN
  score := 0;  removed := 0;
  IF NOT OpenText(input,"DAY09.IN") THEN RAISE FileNotFound END;
  ReadChar(input,c);
  readGroup(1);
  WRITELN('score : ',score);
  WRITELN('removed : ',removed);
END Day09.
