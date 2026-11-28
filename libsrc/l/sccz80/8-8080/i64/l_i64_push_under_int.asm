; sccz80 crt0 library - 8080 version
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
    ex      de,hl                   ;de = source
    pop     bc                      ;return address
    pop     hl                      ;the word
    push    af
    push    af
    push    af
    push    af                      ;room for the 8 bytes
    push    hl
    push    bc
    ld      hl,sp+4
    ex      de,hl
    call    l_i64_cp8
    pop     bc
    pop     hl
    push    bc
    ret
