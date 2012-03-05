;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get returns total sectors on current volume (long)
;
;	$Id: get_total_sectors.asm,v 1.3 2012-03-05 20:40:15 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_total_sectors
	
get_total_sectors:
	call	kjt_get_total_sectors
	ld	h,0
	ld	l,c
	ret
