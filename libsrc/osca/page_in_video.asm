;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: page_in_video.asm,v 1.4 2017-01-02 23:35:59 aralbrec Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  page_in_video
   PUBLIC  _page_in_video

	defc page_in_videp = kjt_page_in_video
	defc _page_in_videp = kjt_page_in_video
	
