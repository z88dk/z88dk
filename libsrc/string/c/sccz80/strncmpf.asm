; strncmp function for use with far pointers

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strncmpf
    PUBLIC _strncmpf


;int strncmpf(far *s1,far *s2,size_t n) __smallc
;
;         if s1==s2 : hl=0
;         if s1<<s2 : hl<0
;         if s1>>s2 : hl>0

IF __CPU_RABBIT__
; Rabbit has no ixl, ixh or iyl: IX stays the frame pointer, the counter is the
; argument cell in the frame and a byte kept over a page-in goes on the stack
.strncmpf
._strncmpf
    push    ix
    ld      ix,4            ; +2 for the pushed IX
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)   ; E'B'C'=s2
    exx
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)   ; EBC=s1
    call    __far_start
    ex      af,af'          ; save seg 1 binding
.strncmp1
    call    __far_page
    ld      a,(hl)          ; char from s1
    push    af              ; Rabbit has no ixl: keep it on the stack over the page-in
    exx
    call    __far_page
    pop     af
    cp      (hl)            ;hl = s2
    jr      nz,different
    and     a
    jr      z,equal
    call    l_far_incptrs   ;inc s2
    exx
    call    l_far_incptrs   ;inc s1
    ld      a,(ix+0)
    or      a
    jr      nz,strncmp2
    dec     (ix+1)
.strncmp2
    dec     (ix+0)
    ld      a,(ix+0)
    or      (ix+1)
    jr      nz,strncmp1
equal:
    ld      hl,0
return:
    ex      af,af'
    call    __far_end
    pop     ix
    ret

different:
    sub     (hl)
    ld      h,a
    jr      return
ELSE
.strncmpf
._strncmpf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    ld      ix,4            ; +2 for the pushed IX
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
    push    hl
    pop     ix
.strncmp1
    call    __far_page
    ld      a,(hl)          ; char from s1
    ld      ixl,a
    exx
    call    __far_page
    ld      a,ixl
    cp      (hl)            ;hl = s2
    jr      nz,different
    and     a
    jr      z,equal
    call    l_far_incptrs   ;inc s2
    exx
    call    l_far_incptrs   ;inc s1
    dec     ix
    ld      a,ixl
    or      ixh
    jr      nz,strncmp1
equal:
    ld      hl,0
return:
    ex      af,af'
    call    __far_end
    pop     ix              ; restore caller's IX
    ret

different:
    sub     (hl)
    ld      h,a
    jr      return
ENDIF
ENDIF
