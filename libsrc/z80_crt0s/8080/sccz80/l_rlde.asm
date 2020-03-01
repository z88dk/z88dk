
SECTION code_crt0_sccz80

PUBLIC l_rlde
; {DE <r<r 1}
l_rlde: 
IF __CPU_8085__
	rl	de
ELSE
	ld	a,e	
	rla
	ld	e,a
	ld	a,d
	rla
	ld	d,a
ENDIF
	ret
