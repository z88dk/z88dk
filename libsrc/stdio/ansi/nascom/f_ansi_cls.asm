;
; 	ANSI Video handling for the NASCOM1/2
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - May 2003
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2003-06-30 15:58:53 stefano Exp $
;

	XLIB	ansi_cls

defc	vram	=	0800h
defc	vl1	=	vram+10
defc	vl2	=	vl1+64
defc	vl15	=	vram+038ah
defc	vend	=	vram+0400h
	

.ansi_cls
	ld	hl,vl1
	push	hl
	ld	b,48
blklp:	ld	(hl),' '
	inc	hl
	djnz	blklp
	; set margin
	ld	b,16
setmgn:	ld	(hl),0
	inc	hl
	djnz	setmgn
	; copy down screen
	ex	de,hl
	pop	hl
	ld	bc,vend-vram-64-10-6
	ldir

	ret
