;
;       Clear Graphics Screen
;
;       Amstrad CPC version by Stefano Bodrato  15/6/2001
;
;
;	$Id: clg.asm,v 1.5 2007-07-21 21:28:22 dom Exp $
;


        XLIB    clg

        INCLUDE "#cpcfirm.def"
        
        INCLUDE	"graphics/grafix.inc"

; Possible colors: 0 (blue), 1 (yellow), 2 (cyan), 3 (red)
;
;

.clg
        ld      a,bcolor
        call    firmware
        defw    gra_set_paper
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen
        call    firmware
        defw    scr_clear
        ret
