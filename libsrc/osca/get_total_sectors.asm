;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get returns total sectors on current volume (long)
;
;	$Id: get_total_sectors.asm,v 1.1 2011-08-04 14:10:13 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_total_sectors
	
get_total_sectors:
	call	kjt_get_total_sectors
	ld	l,e
	ld	h,d
	ld	e,c
	ld	d,0
	ret
