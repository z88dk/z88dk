macro ; no name
X macro
	ld a, 1
endm
X macro ; duplicate definition
	ld a, 2
endm
Y macro
	ld a, 3
endm
Y macro (p1) ; duplicate definition
	ld a, 4
endm
M1 macro ( ; missing close paren
	ld a, 5
endm
M2 macro (21 ; missing parameter
	ld a, 6
endm
M3 macro (p1 p2 ; missing comma
	ld a, p1
	ld b, p2
endm
M4 macro (p1,p1) ; duplicate parameters
	ld a, p1
	ld b, p1
endm
M5 macro (p1,p2) ; parameters in parens
	ld a, p1
	ld b, p2
endm
.label1 M5 1,2 ; expect parens
.label2 M5 (1,2) ; expanded
M6 macro p1,p2 ; paramters without parens
	ld a, p1
	ld b, p2
endm
.label3 M6 1,2 ; expanded
.label4 M6 (1,2) ; only one argmnent
.label5 M6 ; wrong number of arguments
.label6 M6( ; missing ')'
.label6 M6 1) ; missing '('
.label7 M6 1,2,3 ; argument mismatch
.label8 M6 1,(2,3) ; ok
M10 macro 
	ld a,10
endm extra
M11 macro 
	ld a,11
extra endm
