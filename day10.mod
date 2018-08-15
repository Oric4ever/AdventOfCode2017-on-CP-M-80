MODULE Day10;
(*
  Day #10: wrote a KnotHash module in order to reuse it in Day #14
*)
IMPORT KnotHash, Strings;

VAR hash : KnotHash.HASH;
    input : Strings.String;
BEGIN
  input := '192,69,168,160,78,1,166,28,0,83,198,2,254,255,41,12';
  KnotHash.Knot(input,hash);
  KnotHash.WriteHash(hash);
END Day10.
