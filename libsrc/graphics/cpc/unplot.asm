;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: unplot.asm,v 1.4 2015-01-19 01:32:47 pauloscustodio Exp $
;

;Usage: unplot(struct *pixel)


;&BBEA - GRA PLOT ABSOLUTE - Plot a point at an absolute position
;
;Entry:
;
;DE = X coordinate relative to user origin
;HL = Y coordinate relative to user origin




                
        PUBLIC    unplot

        INCLUDE "cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"


.unplot
		ld      a,bcolor
        call    firmware
        defw    gra_set_pen
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
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen
        ret

