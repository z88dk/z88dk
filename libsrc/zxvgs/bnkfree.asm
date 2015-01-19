;ZXVGS specific functions

;020128	(C) created by Yarek

	PUBLIC	bnkfree

;int bnkfree()
;returns number of free memory banks

.bnkfree
	RST	8
	DEFB	$BF
	LD	L,A
	LD	H,0
	RET
