;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fgetc_cons.asm,v 1.1 2011-02-17 20:44:23 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

	ld   a,69h ; keyboard channel
	rst  $30   ; EXOS
	defb 5     ; output to channel

	ld   h,0
	ld   l,b
	ret
