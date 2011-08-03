;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Wait video hardware to be ready
;
;	$Id: change_volume.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  change_volume
	LIB   flos_err
	
change_volume:
	ld	a,l ; __FASTCALL__
	call	kjt_change_volume
	jp		flos_err
