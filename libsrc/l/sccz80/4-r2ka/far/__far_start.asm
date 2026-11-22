; Rabbit far access: save the XPC window page
;
; Exit: a = current XPC low byte (the entry value for __far_end on R2K/R3K)
;
; R4K and later keep the full 12-bit LXPC in a static, so that a far
; access from code that runs with a high LXPC puts it back. hl and the
; other registers are preserved. The static makes far access non-reentrant.

    SECTION code_l_sccz80_far
    PUBLIC  __far_start

IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    PUBLIC  __far_lxpc_save

__far_start:
    push    hl
    ld      hl,lxpc
    ld      (__far_lxpc_save),hl
    ld      a,l
    pop     hl
    ret

    SECTION bss_driver

__far_lxpc_save:
    defw    0
ELSE
__far_start:
    ld      a,xpc
    ret
ENDIF
