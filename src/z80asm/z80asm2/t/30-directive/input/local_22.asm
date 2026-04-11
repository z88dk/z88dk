M1 macro
	L1 local
	L2 local
	L1 local
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endm
M1
M1
rept 2
	L1 local
	L2 local
	L1 local
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
v repti 1, 2
	L1 local
	L2 local
	L1 local
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
v reptc 12
	L1 local
	L2 local
	L1 local
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
