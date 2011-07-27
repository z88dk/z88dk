;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;	int flos_version();
;
;
;	$Id: flos_version.asm,v 1.1 2011-07-27 15:11:27 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  flos_version
	
flos_version:
	jp	kjt_get_version
