## TODO

optimize:
- Fold constant conditions
- Simplify IF diamonds
- Remove redundant GOTOs
- Merge labels
- Dead code elimination
- Peephole optimizations
- Remove unreachable code

- Fold constants at AST level
- PROC inlining
- Control Flow Graph, eliminate empty branches simplify IFs with only one THEN
  statement
- fix goto next line:
		214 IF NOT(A=1)THEN GOTO 220
		216 LET B=2
		218 GOTO 220
	@ZX81BAS3IFELSE:
	@ZX81BAS3IFEND:
		220 ...
- add FOR-NEXT variable to #VARS
- reduce number of temp variables by reusing no longer needed ones
- add ZX-Spectrum BASIC commands
- Fix: emitted code contains empty lines
- Fix: Remove IF 0 THEN ...

