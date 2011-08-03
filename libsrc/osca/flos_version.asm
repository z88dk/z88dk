;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;	int flos_version();
;
;
;	$Id: flos_version.asm,v 1.2 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  flos_version
	
flos_version:
	jp	kjt_get_version
