;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undrawr.asm,v 1.1 2004-07-09 08:57:09 stefano Exp $
;


                XLIB    undrawr
		LIB	drawr

	INCLUDE	"graphics/grafix.inc"

.hlsave		defw	0

.undrawr
	ld	a,bcolor
	call	$BBDE

	pop	hl
	ld	(hlsave),hl
	call	drawr
	ld	hl,(hlsave)
	push	hl

	ld	a,fcolor
	jp	$BBDE

