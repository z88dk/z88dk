;
;	Keyboard routines for the VEB MPM KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;

	SECTION	code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	
	INCLUDE  "target/kc/def/caos.def"

.fgetc_cons
._fgetc_cons
.nokey  call    PV1
        defb    FNKBDZ
        jr      NC,nokey
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
