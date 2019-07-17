        
	SECTION	  code_crt0_sccz80
        PUBLIC    dload
	EXTERN	  fa

;----------------
; Load FA from hl
;----------------
dload:	ld	de,fa
        ld      bc,6
        ldir
        ret

