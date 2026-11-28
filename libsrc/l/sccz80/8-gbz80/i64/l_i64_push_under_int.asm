; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; Insert 8 bytes under the word on top of the stack
;
; enter : hl = source (l_i64_push_under_int_mhl), else __i64_acc is used
;         stack = return address, word
; exit  : stack = the 8 bytes, hl = the word

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_push_under_int
PUBLIC  l_i64_push_under_int_mhl

EXTERN  __i64_acc
EXTERN  l_i64_cp8

l_i64_push_under_int:
    ld      hl,__i64_acc
l_i64_push_under_int_mhl:
    ld      bc,hl                   ;bc = source
    pop     de                      ;return address
    pop     hl                      ;the word
    add     sp,-8
    push    hl
    push    de
    ld      hl,sp+4                 ;the 8-byte room
    ld      de,hl
    ld      hl,bc
    call    l_i64_cp8
    pop     de
    pop     hl
    push    de
    ret
