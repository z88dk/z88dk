#macro X
	ld a, 1
	#exitm
	not reached
#endm
X
#macro Y
	ld a, 2
	X
	ld a, 3
#endm
Y
#macro Z
	ld a, 4
	#rept 2
		#exitm
	#endr
	not reached
#endm
Z