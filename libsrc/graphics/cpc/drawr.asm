;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: drawr.asm,v 1.1 2004-07-09 08:57:09 stefano Exp $
;

;Usage: drawr(struct *pixels)

;&BBF6 - GRA LINE ABSOLUTE - Draw a line to an absolute position
;
;Entry:
;
;DE = X coordinate of endpoint
;HL = Y coordinate of endpoint
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    drawr
 
 
.drawr
		ld	ix,0
		add	ix,sp

		ld	e,(ix+2)	;y1
		ld	d,(ix+3)

		ld	hl,maxy
		sbc	hl,de

		ld	e,(ix+4)	;x1
		ld	d,(ix+5)

		and	a		; double size (?)
		rl	l
		rl	h

		and	a
		rl	e
		rl	d

		jp	$BBF6
