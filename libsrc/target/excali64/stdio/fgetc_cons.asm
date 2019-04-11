;
;
;	getkey() Wait for keypress
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	EXTERN	getk
	EXTERN	msleep
	EXTERN	__CLIB_FGETC_CONS_DELAY

fgetc_cons:
_fgetc_cons:
        ld      hl,__CLIB_FGETC_CONS_DELAY
        call    msleep
loop:
	call	getk
	ld	a,h
	or	l
	jr	z,loop
	ret
