; memset function for use with far pointers

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    EXTERN __far_init    ;Get the initial bindings
    EXTERN __far_reset   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN __far_incptr  ;Increment a far pointer (returning near address)
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
    call    __far_init
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
    call    __far_incptr
    exx
    dec     hl
    jr      memset1

.memset3
    ex      af,af'
    call    __far_reset
    ld      l,(ix+4)
    ld      h,(ix+5)
    ld      e,(ix+6)        ; EHL=s1
    ret
ENDIF
