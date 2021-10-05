        
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    dload
EXTERN	  fa

;----------------
; Load FA from hl
;----------------
dload:	ld	de,fa
IF __CPU_GBZ80__
	ld	b,6
loop:
	ld	a,(hl+)
	ld	(de),a
	inc	de
	dec	b
	jp	nz,loop
ELSE
        ld      bc,6
        ldir
ENDIF
        ret

