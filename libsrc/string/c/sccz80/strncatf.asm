; strncat function for use with far pointers
; 31/3/00 GWL

;
; $Id: strncat_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;
IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC  strncatf
    PUBLIC  _strncatf


;far *strncat(far *s1,far *s2,int n)
; concatenates s2 onto the end of s1 (at most n chars) & null-terminates

.strncatf
._strncatf
    ld      ix,2
    add     ix,sp  
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)        ; E'B'C'=s2
    exx
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)        ; EBC=s1
    call    __far_start
    ex      af,af'          ; save seg 1 binding
    ld      l,(ix+0)
    ld      h,(ix+1)
    push    ix
    push    hl
    pop     ix              ; IX=n
    call    __far_page      ; start with s1
    jr      startfind
.findend
    call    l_far_incptrs
.startfind
    ld      a,(hl)          ; char from s1
    and     a
    jr      nz,findend
    exx                     ; switch to s2
.catloop
    ld      a,ixl
    or      ixh
    jr      z,strncat2	; on if copied n chars already
    call    __far_page
    ld      a,(hl)          ; char from s2
    ld      iyl,a
    call    l_far_incptrs
    exx
    call    __far_page
    ld      a,iyl
    ld      (hl),a          ; place in s1
    call    l_far_incptrs
    exx
    dec     ix
    and     a
    jr      nz,catloop
    jr      strncat3
.strncat2
    exx
    call    __far_page
    ld      (hl),0          ; null-terminate s1
.strncat3
    pop     ix
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=s1
    ret
ENDIF
