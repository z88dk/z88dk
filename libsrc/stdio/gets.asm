;
;	New stdio functions for Small C+
;
;	gets(char *s) - get string from console
;
;
;	$Id: gets.asm,v 1.14 2016-07-02 13:52:42 dom Exp $
;

		MODULE gets
		SECTION	code_clib
		PUBLIC  gets
		PUBLIC  _gets
		EXTERN  fgets_cons

; gets(char *s)
.gets
._gets
	pop	bc
	pop 	hl
	push 	hl
	push 	bc
	push	hl		;str
	ld	bc,65535	
	push	bc		;length
	call	fgets_cons
	pop	bc
	pop	bc
	ret

