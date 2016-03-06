
	PUBLIC	fabandon
	PUBLIC	_fabandon

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
