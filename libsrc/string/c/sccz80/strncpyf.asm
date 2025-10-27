; strncpy function for use with far pointers
; 31/3/00 GWL

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strncpyf
    PUBLIC _strncpyf


;far *strncpy(far *s1,far *s2,int n)
; copies s2 to s1 for exactly n chars, padding with nulls or truncating

.strncpyf
._strncpyf
    ld      ix,2
    add     ix,sp  
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)    ; E'B'C'=s1
    exx
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)    ; EBC=s2
    call    __far_start
    ex      af,af'      ; save seg 1 binding
    ld      l,(ix+0)
    ld      h,(ix+1)    ; HL=n
    push    ix
    push    hl
    pop     ix          ; IX=n
.strncpy1
    ld      a,ixl
    or      ixh
    jr      z,strncpy3	; on if copied n chars
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
    dec     ix
    and     a
    jr      nz,strncpy1
; Now we have reached the end of s2, so pad s1 with nulls (already bound in)
    exx
.strncpy2
    ld      a,ixl
    or      ixh
    jr      z,strncpy3	; on if copied n chars
    ld      (hl),0
    call    l_far_incptrs
    dec     ix
    jr      strncpy2
.strncpy3
    pop     ix
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=s1
    ret
ENDIF
