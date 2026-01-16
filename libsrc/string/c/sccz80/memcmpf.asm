; memcmp function for use with far pointers

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC memcmpf
    PUBLIC _memcmpf


;int memcp(far *s1,far *s2,size_t n) __smallc
;
;         if s1==s2 : hl=0
;         if s1<<s2 : hl<0
;         if s1>>s2 : hl>0

.memcmpf
._memcmpf
    ld      ix,2
    add     ix,sp  
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)    ; E'B'C'=s2
    exx
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)    ; EBC=s1
    call    __far_start
    ex      af,af'      ; save seg 1 binding
    ld      l,(ix+0)
    ld      h,(ix+1)
    push    hl
    pop     ix
.memcmp1
    call    __far_page
    ld      a,(hl)          ; char from s1
    ld      ixl,a
    exx
    call    __far_page
    ld      a,ixl
    cp      (hl)            ;hl = s2
    jr      nz,different
    call    l_far_incptrs  ;inc s2
    exx
    call    l_far_incptrs  ;inc s1
    dec     ix
    ld      a,ixl
    or      ixh
    jr      nz,memcmp1
equal:
    ld      hl,0
return:
    ex      af,af'
    call    __far_end
    ret

different:
    sub     (hl)
    ld      h,a
    jr      return
ENDIF
