; memcpy function for use with far pointers
; 31/3/00 GWL

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC memcpyf
    PUBLIC _memcpyf


;far *memcpyf(far *dst,far *src,size_t n)
; copies n bytes from src to dest
.memcpyf
._memcpyf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    push    iy              ; preserve caller's IY (used as char scratch below)
    ld      ix,6            ; +2 pushed IX +2 pushed IY +2 return address
    add     ix,sp
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)    ; E'B'C'=dst
    exx
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)    ; EBC=src
    call    __far_start
    ex      af,af'      ; save seg 1 binding
    ld      l,(ix+0)
    ld      h,(ix+1)    ; HL=n
    push    ix
    push    hl
    pop     ix          ; IX=n
.memcpy1
    ld      a,ixl
    or      ixh
    jr      z,memcpy3	; on if copied n chars
    call    __far_page
    ld      a,(hl)          ; char from src
    ld      iyl,a
    call    l_far_incptrs
    exx
    call    __far_page
    ld      a,iyl
    ld      (hl),a          ; place at dst
    call    l_far_incptrs
    exx
    dec     ix
    jr      memcpy1
.memcpy3
    pop     ix              ; restore the frame-base IX (saved before the counter loop)
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=dst
    pop     iy              ; restore caller's IY
    pop     ix              ; restore caller's IX
    ret
ENDIF
