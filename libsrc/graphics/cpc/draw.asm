;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;	Draw a line between two points
;
;	$Id: draw.asm,v 1.1 2004-07-09 08:57:09 stefano Exp $
;

;&BBC0 - GRA MOVE ABSOLUTE - Move to an absolute position
;
;Entry:
;
;DE = X coordinate
;HL = y coordinate

;&BBF6 - GRA LINE ABSOLUTE - Draw a line to an absolute position
;
;Entry:
;
;DE = X coordinate of endpoint
;HL = Y coordinate of endpoint
;


	INCLUDE	"graphics/grafix.inc"


                XLIB    draw
 
 
.draw
		ld	ix,0
		add	ix,sp
		push	ix

		ld	e,(ix+6)	;y0
		ld	d,(ix+7)
		
		ld	hl,maxy
		sbc	hl,de

		ld	e,(ix+8)	;x0
		ld	d,(ix+9)

		and	a		; double size (?)
		rl	l
		rl	h

		and	a
		rl	e
		rl	d

		call	$BBC0

		pop	ix
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
