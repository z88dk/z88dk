;
;       Fast CLS for the Speccy
;       Stefano - 10/1/2007
;
;
;	$Id: clg.asm,v 1.2 2007-01-10 20:31:19 stefano Exp $
;

                XLIB    clg

.clg
		ld	hl,0
		ld	d,h
		ld	e,h
		ld	b,h
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

		ld	sp,hl
		ret
