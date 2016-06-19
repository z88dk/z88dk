;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undraw.asm,v 1.5 2016-06-19 21:10:08 dom Exp $
;


        SECTION   code_clib            
        PUBLIC    undraw
        PUBLIC    _undraw
		EXTERN     draw

        INCLUDE "cpcfirm.def"

        INCLUDE	"graphics/grafix.inc"

._undraw
.undraw ld      a,bcolor
        call    firmware
        defw    gra_set_pen
        pop     hl
        ld      (hlsave),hl
        call	draw
        ld      hl,(hlsave)
        push	hl
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen
        ret

	SECTION bss_clib
.hlsave	defw	0
