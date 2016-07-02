
	MODULE  fabandon
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
        ld      (hl),a
        inc     hl
        ld      (hl),a
        inc     hl
        ld      (hl),a
        inc     hl
        ld      (hl),a
	ret
