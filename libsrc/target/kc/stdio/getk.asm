;
;	Keyboard routines for the Robotron VEB KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;

	SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	
	INCLUDE  "target/kc/def/caos.def"

.getk
._getk
	push	iy
	ld	iy,$1f0
;    ld l,0
    call PV1
    defb FNKBDS
	pop	iy
;    jr nc,gkret

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

    ld l, a
;.gkret
	ld	h,0
	ret
