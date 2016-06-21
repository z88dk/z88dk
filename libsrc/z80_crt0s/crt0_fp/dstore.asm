

        SECTION	code_crt0_sccz80
	PUBLIC	dstore
	EXTERN  fa


;--------------
; Copy FA to de
;--------------
dstore: ld      de,fa
        ld      bc,6
        ex      de,hl
        ldir
        ex      de,hl
        ret
