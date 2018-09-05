;
;
;	fgetc_cons() Wait for keypress
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	EXTERN	getk

fgetc_cons:
_fgetc_cons:
loop:
	call	getk
	ld	a,h
	or	l
	jr	z,loop
	ret
