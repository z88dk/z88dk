;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: plot.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

;Usage: plot(struct *pixel)


;&BBEA - GRA PLOT ABSOLUTE - Plot a point at an absolute position
;
;Entry:
;
;DE = X coordinate relative to user origin
;HL = Y coordinate relative to user origin



        XLIB    plot
        
        INCLUDE "cpcfirm.def"              
        INCLUDE	"graphics/grafix.inc"


.plot
		ld      ix,0
		add     ix,sp
		ld      e,(ix+2)
		ld      d,(ix+3)
		ld      hl,maxy
		sbc     hl,de
		ld      e,(ix+4)
		ld      d,(ix+5)
		and     a		; double size (?)
		rl      l
		rl      h
		and     a
		rl      e
		rl      d
        call    firmware
        defw    gra_plot_absolute
        ret
