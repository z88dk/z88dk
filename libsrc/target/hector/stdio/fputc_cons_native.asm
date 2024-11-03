
; Hector support
;

SECTION code_clib

PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

EXTERN  asm_toupper

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    cp      12
    jp      z,cls
    call    asm_toupper
    ld      c,a
    call    $0c67
    ret

cls:
    ld      hl,0
    ld      ($49a6),hl
    jp      $0573
