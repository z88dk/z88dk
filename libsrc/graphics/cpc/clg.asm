;
;       Clear Graphics Screen
;
;       Amstrad CPC version by Stefano Bodrato  15/6/2001
;
;
;	$Id: clg.asm,v 1.4 2004-07-09 08:57:09 stefano Exp $
;


	XLIB    clg


	INCLUDE	"graphics/grafix.inc"

; Possible colors: 0 (blue), 1 (yellow), 2 (cyan), 3 (red)
;
;

.clg
	ld	a,bcolor
	call	$BBE4
	ld	a,fcolor
	call	$BBDE
	jp	$BC14	; clear the screen
