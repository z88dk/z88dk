; strupr function for use with far pointers
; 1/4/00 GWL

;
; $Id: strupr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC struprf
    PUBLIC _struprf


;far *strupr(far *s)
; converts s to uppercase

.struprf
._struprf
    pop     hl
    pop     bc
    pop     de		; EBC=far pointer
    push    de
    push    bc
    push    hl
    call    __far_start
    ex      af,af'
    call    __far_page
.strupr1
    ld      a,(hl)
    and     a
    jr      z,struprend
    cp      'a'
    jr      c,strupr2
    cp      'z'+1
    jr      nc,strupr2
    and     223
    ld      (hl),a
.strupr2
    call    l_far_incptrs
    jr      strupr1
.struprend
    ex      af,af'
    call    __far_end
    pop     hl
    pop     bc
    pop     de      ; get EBC=pointer again
    push    de
    push    bc
    jp      (hl)    ; save 1 byte returning!
ENDIF
