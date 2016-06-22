;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: page_out_video.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  page_out_video

	defc page_out_video = kjt_page_out_video
	defc _page_out_video = kjt_page_out_video
	
