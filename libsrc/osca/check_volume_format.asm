;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: check_volume_format.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  check_volume_format
	PUBLIC  _check_volume_format
	EXTERN   flos_err
	
check_volume_format:
_check_volume_format:
	call	kjt_check_volume_format
	jp   flos_err
