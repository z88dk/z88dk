;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: store_dir_position.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  store_dir_position
	
store_dir_position:
	jp	kjt_store_dir_position
