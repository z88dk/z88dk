macro ; no name
macro X
	ld a, 1
endm
macro X ; duplicate definition
	ld a, 2
endm
macro Y
	ld a, 3
endm
macro Y(p1) ; duplicate definition
	ld a, 4
endm
macro M1( ; missing close paren
	ld a, 5
endm
macro M2(21 ; missing parameter
	ld a, 6
endm
macro M3(p1 p2 ; missing comma
	ld a, p1
	ld b, p2
endm
macro M4(p1,p1) ; duplicate parameters
	ld a, p1
	ld b, p1
endm
macro M5 (p1,p2) ; parameters in parens
	ld a, p1
	ld b, p2
endm
.label1 M5 1,2 ; expect parens
.label2 M5 (1,2) ; expanded
macro M6 p1,p2 ; paramters without parens
	ld a, p1
	ld b, p2
endm
.label3 M6 1,2 ; expanded
.label4 M6 (1,2) ; only one argmnent
.label5 M6 ; wrong number of arguments
.label6 M6( ; missing ')'
.label6 M6 2) ; missing '('
.label7 M6 1,2,3 ; argument mismatch
.label8 M6 1,(2,3) ; ok
macro M10
	ld a,10
endm extra
macro M11
	rept 10
endm
macro M12
	rept 10
		repti v, a, b, c
		endr
endm
macro M13
	ld a,11
extra endm
