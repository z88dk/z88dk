
	SECTION	code_clib

	PUBLIC	copy_font_8x8

	EXTERN	CRT_FONT


; Copy font in PCG area
; Entry: c = number of characters
;       de = address to copy from
;       hl = address for PCG
copy_font_8x8:
copy_1:
        ld      (hl),0
        inc     hl
        ld      b,8
copy_2:
        ld      a,(de)
        ld      (hl),a
        inc     de
        inc     hl
        djnz    copy_2
        ld      b,7
copy_3:
        ld      (hl),0
        inc     hl
        djnz    copy_3
        dec     c
        jr      nz,copy_1
        ret
