;
;	ABC80 Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;
;
;	$Id: fputc_cons.asm,v 1.6 2016-06-12 17:00:21 dom Exp $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native

;
; Entry:        char to print
;


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
IF STANDARDESCAPECHARS
        cp      10      ; CR ?
        jr      nz,nocrlf
	call	printchar
	ld	a,13
ELSE
        cp      13      ; CR ?
        jr      nz,nocrlf
        call    printchar
        ld      a,10
ENDIF
	
.nocrlf
	cp	12	; CLS
	jp	z,$276

.printchar
	ld	bc,1
	ld	hl,mychar
	ld	(hl),a
	jp	1a8h

        SECTION bss_clib
.mychar	defb	0
