;
;       Small C+ Library Functions
;
;	Renamed once more and rechristened for ANSIstdio
;
;	This outputs a character to the console
;
;	1/4/2000 (Original Aug 98)
;
;
;
;	$Id: fputc_cons.asm,v 1.2 2002-10-02 11:21:55 dom Exp $
;


                XLIB    fputc_cons	;Print char

.fputc_cons
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
	cp	8
	jr	nz,fputc_cons1
	ld	c,$53	;CURSOR
	rst	$10
	ld	a,e
	and	a
	ret	z
	dec	e
	ld	c,$52	;LOCATE
	rst	$10
	ret
.fputc_cons1
	cp	13
	jr	nz,fputc_cons2
	ld	a,10
	ld	c,$5b		;PUTCHAR
	rst	$10
	ld	a,13
.fputc_cons2
	ld	c,$5b		;PUTCHAR
	rst	$10
	ret
