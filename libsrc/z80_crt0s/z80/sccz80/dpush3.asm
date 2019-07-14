        
	SECTION	  code_crt0_sccz80
        PUBLIC    dpush3
	EXTERN	  fa

;------------------------------------------------------
; Push FA onto stack under ret address and stacked long
;------------------------------------------------------
dpush3: exx
	pop     hl      ;save return address
        pop     de     ;save next word
	pop	bc	;and the high word
	exx
        ld      hl,(fa+4)
        push    hl
        ld      hl,(fa+2)
        push    hl
        ld      hl,(fa)
        push    hl
	exx
	push	bc
	push	de
	push	hl
	exx
	ret
