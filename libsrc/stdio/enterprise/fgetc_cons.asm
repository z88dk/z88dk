;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

.fgetc_cons

	ld   a,69h ; keyboard channel
	rst  $30   ; EXOS
	defb 5     ; output to channel

	ld   h,0
	ld   l,b
	ret
