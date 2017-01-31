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
	
	INCLUDE  "caos.def"

.getk
._getk
	ld	ix,$1f0
;    ld l,0
    call PV1
    defb FNKBDS
;    jr nc,gkret
    ld l, a
;.gkret
	ld	h,0
	ret
