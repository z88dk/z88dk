;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: page_out_video.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  page_out_video
	
page_out_video:
	jp	kjt_page_out_video
