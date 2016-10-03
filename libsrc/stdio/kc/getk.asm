;
;	Keyboard routines for the Robotron VEB KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2016-10-03 06:38:15 stefano Exp $
;

	SECTION code_clib
	PUBLIC	getk
	
	INCLUDE  "caos.def"

.getk
    ld l,0
    call PV1
    defb FNKBDS
    jr nc,gkret
    ld l, a
.gkret
	ld	h,0
	ret
