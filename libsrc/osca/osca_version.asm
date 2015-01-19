;
;	Get the OSCA Architecture version number
;	by Stefano Bodrato, 2011
;
;	int osca_version();
;
;
;	$Id: osca_version.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  osca_version
	
osca_version:
	call	kjt_get_version
	ld	h,d
	ld	l,e
	ret
