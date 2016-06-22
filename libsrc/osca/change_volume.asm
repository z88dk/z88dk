;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Wait video hardware to be ready
;
;	$Id: change_volume.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  change_volume
	PUBLIC  _change_volume
	EXTERN   flos_err
	
change_volume:
_change_volume:
	ld	a,l ; __FASTCALL__
	call	kjt_change_volume
	jp		flos_err
