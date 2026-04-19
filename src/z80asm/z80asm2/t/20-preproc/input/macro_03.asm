; macro without parameters
macro M1
	ld a,1
endm
.label1 M1
macro M2
	ld a,2
endm
.label2 M2
macro M3
	M1
	M2
endm
.label3 M3
macro M4
	M3
endm
.label4 M4
