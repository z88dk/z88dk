## TODO

- PROC inlining
- Control Flow Graph, eliminate empty branches simplify IFs with only one THEN
  statement
- In FOR make step expression optional
- fix goto next line:
		214 IF NOT(A=1)THEN GOTO 220
		216 LET B=2
		218 GOTO 220
	@ZX81BAS3IFELSE:
	@ZX81BAS3IFEND:
		220 ...
- add FOR-NEXT variable to #VARS

optimize:
- Fold constant conditions
- Simplify IF diamonds
- Remove redundant GOTOs
- Merge labels
- Dead code elimination
- Peephole optimizations
