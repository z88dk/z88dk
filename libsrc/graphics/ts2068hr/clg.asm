;
;       Fast CLS for the Speccy
;       Stefano - 10/1/2007
;
;
;	$Id: clg.asm,v 1.1 2010-11-16 19:41:11 stefano Exp $
;

                XLIB    clg

.clg
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
