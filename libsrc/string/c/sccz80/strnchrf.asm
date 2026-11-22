; strnchr function for use with far pointers



IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strnchrf
    PUBLIC _strnchrf



;far *strnchrf(far *s,size_t n, int c)
; finds pointer to first occurrence of c in s (or NULL if not found)

IF __CPU_RABBIT__
; Rabbit has no ixl, ixh or iyl: IX stays the frame pointer, the counter is the
; argument cell in the frame and a byte kept over a page-in goes on the stack
.strnchrf
._strnchrf
    push    ix
    ld      ix,4            ; +2 pushed IX +2 return address
    add     ix,sp
    ld      c,(ix+4)        ; EBC = far pointer
    ld      b,(ix+5)
    ld      e,(ix+6)
    call    __far_start
    ex      af,af'          ; save seg 1 binding
    ld      a,(ix+2)        ; n == 0 ?
    or      (ix+3)
    jr      z,zeroreturn
    call    __far_page
.strnchrf1
    ld      a,(hl)
    cp      (ix+0)          ; the char argument stays in the frame
    jr      z,strnchrfend   ; finished if found character
    call    l_far_incptrs
    and     a
    jr      z,zeroreturn    ; end of the string
    ld      a,(ix+2)
    or      a
    jr      nz,strnchrf2
    dec     (ix+3)
.strnchrf2
    dec     (ix+2)
    ld      a,(ix+2)
    or      (ix+3)
    jr      nz,strnchrf1
.zeroreturn
    ld      e,a
    ld      b,a
    ld      c,a             ; EBC=NULL, character not found
.strnchrfend
    ld      h,b
    ld      l,c             ; EHL=pointer to character, or NULL
    ex      af,af'
    call    __far_end
    pop     ix
    ld      d,0             ; the far pointer returned has d = 0 (__far_page leaves junk in it)
    ret
ELSE
.strnchrf
._strnchrf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    push    iy              ; preserve caller's IY (used to hold the search char)
    ld      ix,6            ; +2 pushed IX +2 pushed IY +2 return address
    add     ix,sp
    ld      l,(ix+0)    ;IYl = char
    ld      h,0
    push    hl
    pop     iy
    ld      c,(ix+4)    ;EBC = far pointer
    ld      b,(ix+5)
    ld      e,(ix+6)

    call    __far_start
    ex      af,af'  ; save seg 1 binding
    ld      l,(ix+2)    ;hl = n
    ld      h,(ix+3)
    ld      a,l
    or      h
    jr      z,zeroreturn
    push    hl          ;IX = n
    pop     ix
    call    __far_page
.strnchrf1
    ld      a,(hl)
    cp      iyl
    jr      z,strnchrfend	; finished if found character
    call    l_far_incptrs
    dec     ix
    and     a
    jr      z,zeroreturn
    ld      a,ixh
    or      ixl
    jr      nz,strnchrf1
.zeroreturn
    ld      e,a
    ld      b,a
    ld      c,a		; EBC=NULL, character not found
.strnchrfend
    ld      h,b
    ld      l,c		; EHL=pointer to character, or NULL
    ex      af,af'
    call    __far_end
    pop     iy              ; restore caller's IY
    pop     ix              ; restore caller's IX
    ret
ENDIF
ENDIF
