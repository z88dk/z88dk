;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: unplot.asm,v 1.1 2005-03-02 08:27:35 stefano Exp $
;

;Usage: unplot(struct *pixel)


;&BBEA - GRA PLOT ABSOLUTE - Plot a point at an absolute position
;
;Entry:
;
;DE = X coordinate relative to user origin
;HL = Y coordinate relative to user origin


	INCLUDE	"graphics/grafix.inc"


                XLIB    unplot

.unplot
		ld	a,bcolor
		call	$BBDE

		ld	ix,0
		add	ix,sp
		
		ld	e,(ix+2)
		ld	d,(ix+3)

		ld	hl,maxy
		sbc	hl,de

		ld	e,(ix+4)
		ld	d,(ix+5)

		and	a		; double size (?)
		rl	l
		rl	h

		and	a
		rl	e
		rl	d

                call      $BBEA
             
             	ld	a,fcolor
		jp	$BBDE

