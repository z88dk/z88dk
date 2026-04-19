macro M1
	local L1, L2
	local L1
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endm
M1
M1
rept 2
	local L1, L2
	local L1
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
repti v, 1, 2
	local L1, L2
	local L1
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
reptc v, 12
	local L1, L2
	local L1
L1:	jr L1
L2: jr L2
L3: jr L3 ; not replaced
endr
