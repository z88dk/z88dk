;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Wait video hardware to be ready
;
;	$Id: wait_vrt.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  wait_vrt
	PUBLIC  _wait_vrt

	defc wait_vrt = kjt_wait_vrt	
	defc _wait_vrt = kjt_wait_vrt	
