;
; 	ANSI Video handling for the NASCOM1/2
;
;	Scrollup
;
;	Stefano Bodrato - May 2003
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2003-06-30 15:58:53 stefano Exp $
;


	XLIB	ansi_SCROLLUP

defc	vram	=	0800h
defc	vl1	=	vram+10
defc	vl2	=	vl1+64
defc	vl15	=	vram+038ah
defc	vend	=	vram+0400h


.ansi_SCROLLUP
	
	; first line (weird, isn't it?)
	ld	hl,$80a
	ld	de,$bca
	ld	bc,48
	ldir

	; all the other lines
	ld	de,vl1
	ld	hl,vl2
	ld	bc,vend-vram-64-64-16
	ldir

	; clear bottom line
	ld	b,48
clloop:	dec	hl
	ld	(hl),' '
	djnz	clloop

	ret
