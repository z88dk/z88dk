;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undraw.asm,v 1.1 2004-07-09 08:57:09 stefano Exp $
;


                XLIB    undraw
		LIB	draw

	INCLUDE	"graphics/grafix.inc"

.hlsave		defw	0

.undraw
	ld	a,bcolor
	call	$BBDE

	pop	hl
	ld	(hlsave),hl
	call	draw
	ld	hl,(hlsave)
	push	hl

	ld	a,fcolor
	jp	$BBDE
