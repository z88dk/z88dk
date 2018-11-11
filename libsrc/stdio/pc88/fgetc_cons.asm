;
;	NEC PC8801 Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2018
;
;
;	$Id: fgetc_cons.asm $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	EXTERN	getk

;         INCLUDE "target/pc88/def/n88bios.def"


.fgetc_cons
._fgetc_cons
	push	ix
	;call	CHGET
.wkey
;	call 3241h
;	jr nc,wkey
	call getk
	and a
	jr	nz,wkey
.wkey1
	call getk
	and a
	jr	z,wkey1
	
	pop	ix

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
