

        SECTION	code_crt0_sccz80
	PUBLIC	dstore
	EXTERN  fa


;--------------
; Copy FA to hl
;--------------
dstore: ld      de,fa
        ld      bc,6
        ex      de,hl
        ldir
        ex      de,hl	; returns de=fa+6, hl=hl+6
        ret
