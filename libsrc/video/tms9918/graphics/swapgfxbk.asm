;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.7 2017-01-02 22:57:58 aralbrec Exp $
;

MODULE    __tms9918_swapgfxbk
SECTION   code_video_vdp
PUBLIC    swapgfxbk
PUBLIC	swapgfxbk1

.swapgfxbk
.swapgfxbk1
    ret
