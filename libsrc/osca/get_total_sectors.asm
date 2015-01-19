;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get returns total sectors on current volume (long)
;
;	$Id: get_total_sectors.asm,v 1.5 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_total_sectors
	
get_total_sectors:
	call	kjt_get_total_sectors
	ld	h,0
	ld	l,c
	ret
