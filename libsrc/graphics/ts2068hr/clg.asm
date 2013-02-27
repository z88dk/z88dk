;
;       Fast CLS for the Speccy
;       Stefano - 10/1/2007
;
;
;	$Id: clg.asm,v 1.2 2013-02-27 12:53:28 stefano Exp $
;

                XLIB    clg

.clg
		in	a,(255)
		and	@11111000
		or	@00000110
		out     (255),a

		ld	hl,0
		ld	d,h
		ld	e,h
		ld	b,h
		ld	c,b
		add	hl,sp
		ld	sp,16384+6144
.clgloop
		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		djnz	clgloop

		ld	b,c
		ld	sp,24576+6144

.clgloop2
		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		djnz	clgloop2

		ld	sp,hl
		ret
