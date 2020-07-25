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
	cp	10
	jp	nz,notcr
	ld	a,13
	jp	printit
notcr:	cp	13
	jp	nz,printit
	ld	a,10
printit:
	rst	$28
	defb	dai_SCR_OUTC
;	call	dai_PRINTC	
	ret
