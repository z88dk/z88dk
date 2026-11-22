
; gbz80 software frame-pointer chain for -debug (see the 8080 version).
; Net effect: push the caller's __debug_framepointer (2 bytes, between the
; return address and the locals) and point __debug_framepointer at that save,
; so the debugger can walk frames and resolve cdb ,B,1,d records.
;
; gbz80 has no `ex (sp),hl` / `ex de,hl`, so the frame-pointer save is done in
; a stack slot that first holds the caller's DE, and the two are swapped through
; (hl) once its address is known. Preserves HL and DE (a __z88dk_fastcall long or
; float arrives in DEHL, and a fastcall/__sdcccall arg may be in DE); clobbers BC,
; A and flags.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_debug_push_frame
EXTERN __debug_framepointer

l_debug_push_frame:
    pop     bc                          ; bc = return address into the body
    push    de                          ; slot for the saved frame pointer (holds de for now)
    push    hl                          ; park caller's hl
    ld      a,(__debug_framepointer)
    ld      e,a
    ld      a,(__debug_framepointer+1)
    ld      d,a                         ; de = caller's frame pointer
    ld      hl,sp+2                     ; hl = &slot
    ld      a,l
    ld      (__debug_framepointer),a
    ld      a,h
    ld      (__debug_framepointer+1),a  ; __debug_framepointer = this frame
    ld      a,(hl)                      ; swap de with the slot: a = caller's e
    ld      (hl),e                      ;   slot.lo = frame pointer lo
    ld      e,a                         ;   e = caller's e
    inc     hl
    ld      a,(hl)
    ld      (hl),d                      ;   slot.hi = frame pointer hi
    ld      d,a                         ;   d = caller's d
    pop     hl                          ; restore caller's hl
    push    bc                          ; return address back
    ret
