; memset function for use with far pointers

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far

    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC memsetf
    PUBLIC _memsetf


;far *memset(far *s1,int c, size_t len)
; memset(void *b, int c, size_t len);

.memsetf
._memsetf
    ld      ix,2
    add     ix,sp  
    ld      c,(ix+4)
    ld      b,(ix+5)
    ld      e,(ix+6)    ; E'B'C'=s1
    exx
    call    __far_start
    ex      af,af'      ; save seg 1 binding
    ld      c,(ix+2)    ; c = c
    ld      l,(ix+0)
    ld      h,(ix+1)    ; HL=n
    exx
    call    __far_page
    exx
.memset1
    ld      a,l
    or      h
    jr      z,memset3	; on if set n chars
    ld      a,c
    exx
    ld      (hl),a
    call    l_far_incptrs
    exx
    dec     hl
    jr      memset1

.memset3
    ex      af,af'
    call    __far_end
    ld      l,(ix+4)
    ld      h,(ix+5)
    ld      e,(ix+6)        ; EHL=s1
    ret
ENDIF
