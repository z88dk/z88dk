;
; void textbackground(int c) __z88dk_fastcall;
;
; Change the background colour going forward
; 

	PUBLIC	textbackground
	PUBLIC	_textbackground

	SECTION	code_clib

	EXTERN	generic_console_set_paper


textbackground:
_textbackground:
	ld	a,l
	jp	generic_console_set_paper
	
