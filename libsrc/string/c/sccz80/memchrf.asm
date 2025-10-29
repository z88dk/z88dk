; memchr function for use with far pointers



IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC memchrf
    PUBLIC _memchrf



;far *memchrf(far *s,int c, size_t n)
; finds pointer to first occurrence of c in s (or NULL if not found)

.memchrf
._memchrf
    ld      ix,2
    add     ix,sp
    ld      l,(ix+2)    ;IYl = char
    ld      h,0
    push    hl
    pop     iy
    ld      c,(ix+4)    ;EBC = far pointer
    ld      b,(ix+5)
    ld      e,(ix+6)

    call    __far_start
    ex      af,af'  ; save seg 1 binding
    ld      l,(ix+0)    ;hl = n
    ld      h,(ix+1)
    ld      a,l
    or      h
    jr      z,zeroreturn
    push    hl          ;IX = n
    pop     ix
    call    __far_page
.memchrf1
    ld      a,(hl)
    cp      iyl
    jr      z,memchrfend	; finished if found character
    call    l_far_incptrs
    dec     ix
    ld      a,ixh
    or      ixl
    jr      nz,memchrf1
.zeroreturn
    ld      e,a
    ld      b,a
    ld      c,a		; EBC=NULL, character not found
.memchrfend
    ld      h,b
    ld      l,c		; EHL=pointer to character, or NULL
    ex      af,af'
    call    __far_end
    ret
ENDIF
