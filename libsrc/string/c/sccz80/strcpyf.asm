; strcpy function for use with far pointers
; 31/3/00 GWL

;
; $Id: strcpyf.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;


IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_KC160__
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

IF __CPU_RABBIT__
; Rabbit has no ixl, ixh or iyl: IX stays the frame pointer, the counter is the
; argument cell in the frame and a byte kept over a page-in goes on the stack
.strcpyf
._strcpyf
    push    ix
    ld      ix,4            ; +2 pushed IX +2 return address
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
    push    af              ; Rabbit has no iyl: keep it on the stack over the page-in
    call    l_far_incptrs
    exx
    call    __far_page
    pop     af
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
    ld      d,0             ; the far pointer returned has d = 0 (__far_page leaves junk in it)
    ret
ELSE
.strcpyf
._strcpyf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    push    iy              ; preserve caller's IY (used as char scratch below)
    ld      ix,6            ; +2 pushed IX +2 pushed IY +2 return address
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
    pop     iy              ; restore caller's IY
    pop     ix              ; restore caller's IX
    ret
ENDIF
ENDIF
