; macro without parameters
M1 macro 
	ld a,1
endm
.label1 M1
M2 macro 
	ld a,2
endm
.label2 M2
M3 macro 
	M1
	M2
endm
.label3 M3
M4 macro 
	M3
endm
.label4 M4
