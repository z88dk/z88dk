;
;       Fast CLS for the Speccy
;       Stefano - 10/1/2007
;
;
;	$Id: clg.asm,v 1.3 2013-09-17 12:00:07 stefano Exp $
;

        XLIB    clg

.clg
        ld a,i
        push af
        di

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
        pop af
        ret po
        ei
        ret
