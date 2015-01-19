;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;	int flos_version();
;
;
;	$Id: flos_version.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  flos_version
	
flos_version:
	jp	kjt_get_version
