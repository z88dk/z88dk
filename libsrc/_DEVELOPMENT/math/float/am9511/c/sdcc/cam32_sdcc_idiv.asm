
; int __idiv (int left, int right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_idivs, cam32_sdcc_idivu

EXTERN cam32_sdcc_ireadr, asm_am9511_idiv

.cam32_sdcc_idivs

    ; divide sdcc int by sdcc int
    ;
    ; enter : stack = sdcc_int right, sdcc_int left, ret
    ;
    ; exit  : DEHL = sdcc_int(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_ireadr
    jp asm_am9511_idiv      ; enter stack = sdcc_int right, sdcc_int left, ret
                            ;        DEHL = sdcc_int right
                            ; return DEHL = sdcc_int


.cam32_sdcc_idivu

    ; divide sdcc int by sdcc int
    ;
    ; enter : stack = sdcc_int right, sdcc_int left, ret
    ;
    ; exit  : DEHL = sdcc_int(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_ireadr
    res 7,h                 ; unsigned divisor
    jp asm_am9511_idiv      ; enter stack = sdcc_int right, sdcc_int left, ret
                            ;        DEHL = sdcc_int right
                            ; return DEHL = sdcc_int
