;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2016-06-12 16:06:43 dom Exp $
;


        SECTION code_clib
	PUBLIC	ansi_del_line
	EXTERN	base_graphics


.ansi_del_line
	ld	de,32*8
	ld	b,a
	ld  hl,$e000
	and	a
	jr	z,zline
.lloop
	add	hl,de
	djnz	lloop
.zline	
	ld	d,h
	ld	e,l
	inc	de
	ld	(hl),0
	ld	bc,32*8
	ldir
	
	ret
