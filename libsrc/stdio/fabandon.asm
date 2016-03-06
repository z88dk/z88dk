
	PUBLIC	fabandon
	PUBLIC	_fabandon

	SECTION	code_clib

fabandon:
_fabandon:
        pop     de
        pop     hl
        push    hl
        push    de
        xor     a
        ld      (hl),0
        inc     hl
        ld      (hl),0
        inc     hl
        ld      (hl),0
        inc     hl
        ld      (hl),0
	ret
