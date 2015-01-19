;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: check_volume_format.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  check_volume_format
	EXTERN   flos_err
	
check_volume_format:
	call	kjt_check_volume_format
	jp   flos_err
