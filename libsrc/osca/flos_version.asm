;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;	int flos_version();
;
;
;	$Id: flos_version.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  flos_version
	PUBLIC  _flos_version

	defc	flos_version = kjt_get_version	
	defc	_flos_version = kjt_get_version	
