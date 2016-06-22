;
;	Get the OSCA Architecture version number
;	by Stefano Bodrato, 2011
;
;	int osca_version();
;
;
;	$Id: osca_version.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  osca_version
	PUBLIC  _osca_version
	
osca_version:
_osca_version:
	call	kjt_get_version
	ld	h,d
	ld	l,e
	ret
