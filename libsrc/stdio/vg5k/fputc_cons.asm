;
;    Philips VG5000 Routines
;
;    Print character to the screen
;
;    Jun. 2014 -Joaopa
;
;
;    $Id: fputc_cons.asm,v 1.1 2014-07-07 08:25:21 stefano Exp $
;

    XLIB  fputc_cons
;
; Entry:        char to print
;
.fputc_cons
	push	bc
	push	af
	push	de
	ld	hl, 2
	add	hl, sp
	ld	d, (hl); Now D contains the char
	ld	a, (18434)
	ld	e, a
	call	149

	pop	de
	pop	af
	pop	bc
	ret
