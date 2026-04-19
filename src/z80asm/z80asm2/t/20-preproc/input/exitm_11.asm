#exitm ; outside macro
#macro X
	#exitm extra ; extra input
#endm
X
#rept 2
	#exitm ; outside macro
#endr
#repti v, 1, 2
	#exitm ; outside macro
#endr
#reptc v, 12
	#exitm ; outside macro
#endr
