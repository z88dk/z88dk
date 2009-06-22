;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undraw.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;


            
        XLIB    undraw
		LIB     draw

        INCLUDE "cpcfirm.def"

        INCLUDE	"graphics/grafix.inc"

.hlsave	defw	0

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
