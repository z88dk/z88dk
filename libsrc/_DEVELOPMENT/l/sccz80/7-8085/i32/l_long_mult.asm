;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_mult

EXTERN  l_mult_0
EXTERN  l_mult_ulong_0

;primary = secondary * primary
;enter with secondary in dehl, primary on stack
;exit with product in dehl
.l_long_mult
    pop     bc                  ;get return
    push    de                  ;put secondary on stack
    push    hl
    push    bc                  ;replace return

    ld      bc,hl               ;secondary LSW

    ld      de,sp+6             ;primary LSW addr
    ld      hl,(de)
    ex      de,hl

    call    l_mult_ulong_0      ;dehl = de * bc

    push    hl                  ;result LSW
    push    de                  ;partial result MSW

    ld      de,sp+6             ;secondary LSW addr
    ld      hl,(de)
    ld      bc,hl

    ld      de,sp+12            ;primary MSW addr
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc
    push    hl

    ld      de,sp+8             ;secondary MSW addr
    ld      hl,(de)
    ld      bc,hl

    ld      de,sp+10            ;primary LSW addr
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc               ;result MSW

    pop     bc                  ;result LSW
    pop     af                  ;return

    ld      de,sp+8             ;remove secondary and primary from stack
    ex      de,hl
    ld      sp,hl

    ld      hl,bc               ;result LSW

    push    af                  ;replace return
    ret
