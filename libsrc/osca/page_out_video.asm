;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: page_out_video.asm,v 1.4 2017-01-02 23:35:59 aralbrec Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  page_out_video
   PUBLIC  _page_out_video

	defc page_out_video = kjt_page_out_video
	defc _page_out_video = kjt_page_out_video
	
