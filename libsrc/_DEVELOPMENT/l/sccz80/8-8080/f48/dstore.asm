

        SECTION	code_crt0_sccz80
	PUBLIC	dstore
	EXTERN  fa


;--------------
; Copy FA to hl
;--------------
dstore: ld      de,fa
IF __CPU_INTEL__
	ld	b,6
loop:
	ld	a,(de)
	ld	(hl),a
	inc	hl
	inc	de
	dec	b
	jp	nz,loop
ELSE
        ex      de,hl
        ld      bc,6
        ldir
        ex      de,hl	; returns de=fa+6, hl=hl+6
ENDIF
        ret
