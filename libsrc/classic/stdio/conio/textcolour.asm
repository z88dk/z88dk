;
; void textcolour(int c) __z88dk_fastcall;
;
; Change the foreground colour going forward
; 

	PUBLIC	textcolour
	PUBLIC	_textcolour
	PUBLIC	textcolor
	PUBLIC	_textcolor

	SECTION	code_clib

	EXTERN	generic_console_set_ink


textcolour:
_textcolour:
textcolor:
_textcolor:
	ld	a,l
	jp	generic_console_set_ink
	
