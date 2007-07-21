;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undrawr.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;


                
        XLIB    undrawr
		LIB     drawr

        INCLUDE "#cpcfirm.def"

        INCLUDE	"graphics/grafix.inc"

.hlsave	defw	0

.undrawr
        ld      a,bcolor
        call    firmware
        defw    gra_set_pen
        pop     hl
        ld      (hlsave),hl
        call	drawr
        ld      hl,(hlsave)
        push	hl
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen
        ret

