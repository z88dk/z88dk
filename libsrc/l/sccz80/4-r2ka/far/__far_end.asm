; Rabbit far access: restore the XPC window page
;
; Entry: a = XPC saved by __far_start (R2K/R3K)
;
; R4K and later restore the 12-bit LXPC that __far_start saved. hl holds
; the result of a far read, so it is preserved.

    SECTION code_l_sccz80_far
    PUBLIC  __far_end

IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    EXTERN  __far_lxpc_save

__far_end:
    push    hl
    ld      hl,(__far_lxpc_save)
    ld      lxpc,hl
    pop     hl
    ret
ELSE
__far_end:
    ld      xpc,a
    ret
ENDIF
