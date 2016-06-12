;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons

.fgetc_cons

	ld   a,69h ; keyboard channel
	rst  $30   ; EXOS
	defb 5     ; output to channel

	ld   h,0
	ld   l,b
	ret
