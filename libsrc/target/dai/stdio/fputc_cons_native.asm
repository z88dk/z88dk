;
; Print character to screen using firmware
;

	SECTION	code_clib
        PUBLIC  fputc_cons_native

	INCLUDE	"target/dai/def/dai.def"

;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld	d,0
	ld	a,(hl)
	call	dai_PRINTC	
	ret
