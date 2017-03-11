

        SECTION	code_crt0_sccz80
	PUBLIC	dswap
	EXTERN  fa


;--------------
; Swap FA and double at hl
;--------------
dswap:
	ld	b,6
	ld	de,fa
dswap1:	ld	a,(de)
	ld	c,(hl)
	ld	(hl),a
	ld	a,c
	ld	(de),a
	inc	hl
	inc	de
	djnz	dswap1
	ret
