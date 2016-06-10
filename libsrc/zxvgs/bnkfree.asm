;ZXVGS specific functions

;020128	(C) created by Yarek

	SECTION	code_clib
	PUBLIC	bnkfree
	PUBLIC	_bnkfree

;int bnkfree()
;returns number of free memory banks

.bnkfree
._bnkfree
	RST	8
	DEFB	$BF
	LD	L,A
	LD	H,0
	RET
