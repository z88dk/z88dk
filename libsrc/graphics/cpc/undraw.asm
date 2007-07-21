;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undraw.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;


            
        XLIB    undraw
		LIB     draw

        INCLUDE "#cpcfirm.def"

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
