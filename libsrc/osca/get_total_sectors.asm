;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get returns total sectors on current volume (long)
;
;	$Id: get_total_sectors.asm,v 1.6 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_total_sectors
	PUBLIC  _get_total_sectors
	
get_total_sectors:
_get_total_sectors:
	call	kjt_get_total_sectors
	ld	h,0
	ld	l,c
	ret
