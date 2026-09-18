## TODO

- remove unused labels
- generate output file
- lower VARS section
- Assign ZX81 line numbers
- Convert ASCII strings to ZX81 character set.
- Write .P
- Constant folding
- Dead code elimination
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
- fix NOT(A=1)
		214 IF NOT(A=1)THEN GOTO 220
- fix PEEK(16384+1) after lowering of PEEKW

The clean architecture
semantic_transform()
- Expand PEEKW/POKEW
- Expand DIV/MOD
- Expand FN
- Fold constant expressions

Produce canonical AST

lower_prog()
- Lower IF/WHILE/FOR/PROC/EXIT
- Produce flat ZX81 BASIC IR
No constant folding here

optimize()
- Fold constant conditions
- Simplify IF diamonds
- Remove redundant GOTOs
- Merge labels
- Dead code elimination
- Peephole optimizations
