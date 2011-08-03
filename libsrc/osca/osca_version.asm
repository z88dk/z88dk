;
;	Get the OSCA Architecture version number
;	by Stefano Bodrato, 2011
;
;	int osca_version();
;
;
;	$Id: osca_version.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  osca_version
	
osca_version:
	call	kjt_get_version
	ld	h,d
	ld	l,e
	ret
