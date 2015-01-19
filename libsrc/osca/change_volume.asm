;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Wait video hardware to be ready
;
;	$Id: change_volume.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  change_volume
	EXTERN   flos_err
	
change_volume:
	ld	a,l ; __FASTCALL__
	call	kjt_change_volume
	jp		flos_err
