; strcpy function for use with far pointers
; 31/3/00 GWL

;
; $Id: strcpyf.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;


IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strcpyf
    PUBLIC _strcpyf



;far *strcpy(far *s1,far *s2)
; copies s2 to s1

.strcpyf
._strcpyf
    push    ix 
    ld      ix,4
    add     ix,sp  
    ld      c,(ix+4)
    ld      b,(ix+5)
    ld      e,(ix+6)        ; E'B'C'=s1
    exx
    ld      c,(ix+0)
    ld      b,(ix+1)
    ld      e,(ix+2)        ; EBC=s2
    call    __far_start
    ex      af,af'          ; save original binding
.strcpy1
    call    __far_page
    ld      a,(hl)          ; char from s2
    ld      iyl,a
    call    l_far_incptrs
    exx
    call    __far_page
    ld      a,iyl
    ld      (hl),a          ; place at s1
    call    l_far_incptrs
    exx
    and     a
    jr      nz,strcpy1
    ex      af,af'
    call    __far_end
    ld      l,(ix+4)
    ld      h,(ix+5)
    ld      e,(ix+6)        ; EHL=s1
    pop     ix
    ret
ENDIF
