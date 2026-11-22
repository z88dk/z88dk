
; gbz80 teardown for the software frame-pointer chain (see l_debug_push_frame).
; Restores the caller's __debug_framepointer from the 2-byte save and removes it.
; Preserves HL and DE (the return value lives in HL / DEHL at the epilogue);
; clobbers BC, A, flags.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_debug_pop_frame
EXTERN __debug_framepointer

l_debug_pop_frame:
    pop     bc                          ; bc = return address into the epilogue
    push    de                          ; save de (return value high half)
    push    hl                          ; save hl (return value)
    ld      hl,4
    add     hl,sp                       ; hl = &saved frame pointer
    ld      a,(hl+)
    ld      (__debug_framepointer),a
    ld      a,(hl)
    ld      (__debug_framepointer+1),a  ; restore caller's frame pointer
    pop     hl                          ; restore hl
    pop     de                          ; restore de
    inc     sp
    inc     sp                          ; drop the saved frame pointer
    push    bc                          ; return address back
    ret
