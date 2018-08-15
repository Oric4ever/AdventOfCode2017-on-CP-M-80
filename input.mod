IMPLEMENTATION MODULE Input;
IMPORT Texts;
VAR input : Texts.TEXT;
EXCEPTION FileNotFound;

PROCEDURE Open(fileName : ARRAY OF CHAR):Texts.TEXT;
VAR input : Texts.TEXT;
BEGIN
  IF NOT Texts.OpenText(input,fileName) THEN RAISE FileNotFound,fileName; END;
  RETURN input;
END Open;

PROCEDURE ReadCharInput(fileName : ARRAY OF CHAR;
                        VAR data : ARRAY OF CHAR;
                        VAR size : CARDINAL);
VAR c : CHAR;
BEGIN
  input := Open(fileName);
  size := 0;
  LOOP
    Texts.ReadChar(input,c);
    IF Texts.EOT(input) THEN EXIT END;
    data[size] := c;
    INC(size);
  END;
  Texts.CloseText(input);
END ReadCharInput;

PROCEDURE ReadIntegerInput(fileName : ARRAY OF CHAR;
                           VAR data : ARRAY OF INTEGER;
                           size : CARDINAL);
VAR i : CARDINAL;
BEGIN
  input := Open(fileName);
  FOR i:=0 TO size-1 DO Texts.ReadInt(input,data[i]) END;
  Texts.CloseText(input);
END ReadIntegerInput;

END Input.

