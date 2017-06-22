;
;	Sharp PC G-800 family stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2017
;
;
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	


.fgetc_cons
._fgetc_cons

	
	; PC-G850
	call $bcc4


IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret

