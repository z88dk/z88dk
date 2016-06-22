;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: page_in_video.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  page_in_video

	defc page_in_videp = kjt_page_in_video
	defc _page_in_videp = kjt_page_in_video
	
