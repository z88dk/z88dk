;
;	ABC80 Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;


          XLIB  fputc_cons

;
; Entry:        char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
	

	ret
