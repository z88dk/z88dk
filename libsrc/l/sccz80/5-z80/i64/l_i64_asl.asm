
    SECTION code_l_sccz80
    PUBLIC  l_i64_asl
    PUBLIC  l_i64_aslo
    EXTERN  __i64_acc
    EXTERN  l_lsl_dehldehl

; Entry: __i64_acc = shift count
;        sp + 2    = value to shift

l_i64_asl:
    ld    a,(__i64_acc+0)
l_i64_aslo:
    pop   bc
    pop   hl
    pop   de
    exx
    pop   hl
    pop   de
    exx
    push  bc
    call  l_lsl_dehldehl
    ld    (__i64_acc+0),hl
    ld    (__i64_acc+2),de
    exx
    ld    (__i64_acc+4),hl
    ld    (__i64_acc+6),de
    ret
