;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;	Draw a line between two points
;
;	$Id: draw.asm,v 1.5 2016-06-19 21:10:08 dom Exp $
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



        SECTION   code_clib
        PUBLIC    draw
        PUBLIC    _draw

        INCLUDE "cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"

.draw
._draw
		push	ix
		ld      ix,2
		add     ix,sp
		push	ix

		ld      e,(ix+6)	;y0
		ld      d,(ix+7)
		
		ld      hl,maxy
		sbc     hl,de

		ld      e,(ix+8)	;x0
		ld      d,(ix+9)

		and     a		; double size (?)
		rl      l
		rl      h

		and     a
		rl      e
		rl      d

        call    firmware
        defw    gra_move_absolute

		pop     ix
		ld      e,(ix+2)	;y1
		ld      d,(ix+3)

		ld      hl,maxy
		sbc     hl,de

		ld      e,(ix+4)	;x1
		ld      d,(ix+5)

		and     a		; double size (?)
		rl      l
		rl      h

		and     a
		rl      e
		rl      d

        call    firmware
        defw    gra_line_absolute
	pop	ix
        ret

