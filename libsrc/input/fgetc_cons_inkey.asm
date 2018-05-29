;
; Implementation of fgetc_cons() without calling any ROM routines
;
;

	        SECTION code_clib
		PUBLIC  fgetc_cons_inkey
                PUBLIC  _fgetc_cons_inkey
		PUBLIC	getk_inkey
		PUBLIC	_getk_inkey

		EXTERN	msleep
                EXTERN in_GetKey
		EXTERN	__CLIB_FGETC_CONS_DELAY

getk_inkey:
_getk_inkey:
	call	in_GetKey
	jr	continue

.fgetc_cons_inkey
._fgetc_cons_inkey
	ld	hl,__CLIB_FGETC_CONS_DELAY
	call	msleep
loop:
	call	in_GetKey
	jr	c,loop


continue:
	ld	a,l
	cp	13
	jr	nz,notCR
	ld	l,10
notCR:
	cp	10
	jr	nz,notLF
	ld	l,13
notLF:
	cp	4	;EOF
	ret	nz
	ld	hl,-1
	ret
