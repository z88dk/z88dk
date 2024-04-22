; strlwr function for use with far pointers
; 1/4/00 GWL

;
; $Id: strlwr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;


IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strlwrf
    PUBLIC _strlwrf

;far *strlwr(far *s)
; converts s to lowercase

.strlwrf
._strlwrf
    pop     hl
    pop     bc
    pop     de      ; EBC=far pointer
    push    de
    push    bc
    push    hl
    call    __far_start
    ex      af,af'      ; save seg 1 binding
    call    __far_page
.strlwr1
    ld      a,(hl)
    and     a
    jr      z,strlwrend
    cp      'A'
    jr      c,strlwr2
    cp      'Z'+1
    jr      nc,strlwr2
    or      32
    ld      (hl),a
.strlwr2
    call    l_far_incptrs
    jr      strlwr1
.strlwrend
    ex      af,af'
    call    __far_end
    pop     hl
    pop     bc
    pop     de      ; get EBC=pointer again
    push    de
    push    bc
    jp      (hl)    ; save 1 byte returning!
ENDIF
