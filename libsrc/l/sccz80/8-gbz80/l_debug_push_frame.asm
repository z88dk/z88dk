
; gbz80 software frame-pointer chain for -debug (see the 8080 version).
; Net effect: push the caller's __debug_framepointer (2 bytes, between the
; return address and the locals) and point __debug_framepointer at that save,
; so the debugger can walk frames and resolve cdb ,B,1,d records.
;
; gbz80 has no `ex (sp),hl` / `ex de,hl`, so the caller's HL is parked in DE
; while the frame pointer is read and the new base computed with `add hl,sp`.
; Preserves HL; clobbers DE, BC, A. DE is dead at prologue entry for the common
; (SMALLC, stack-arg) case; only fastcall/__sdcccall args passed in DE are not
; preserved across the debug frame here.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_debug_push_frame
EXTERN __debug_framepointer

l_debug_push_frame:
    pop     bc                          ; bc = return address into the body
    ld      d,h
    ld      e,l                         ; de = caller's hl (parked)
    ld      a,(__debug_framepointer)
    ld      l,a
    ld      a,(__debug_framepointer+1)
    ld      h,a                         ; hl = caller's frame pointer
    push    hl                          ; save it (this function's frame slot)
    ld      hl,0
    add     hl,sp                       ; hl = &saved frame pointer
    ld      a,l
    ld      (__debug_framepointer),a
    ld      a,h
    ld      (__debug_framepointer+1),a  ; __debug_framepointer = this frame
    ld      h,d
    ld      l,e                         ; restore caller's hl
    push    bc                          ; return address back
    ret
