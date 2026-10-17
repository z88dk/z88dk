; memcpy function for use with far pointers
; 31/3/00 GWL

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_KC160__
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
IF __CPU_RABBIT__
; Rabbit has no ixl, ixh or iyl: IX stays the frame pointer, the counter is the
; argument cell in the frame and a byte kept over a page-in goes on the stack
.memcpyf
._memcpyf
    push    ix
    ld      ix,4            ; +2 pushed IX +2 return address
    add     ix,sp
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)        ; E'B'C'=dst
    exx
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)        ; EBC=src
    call    __far_start
    ex      af,af'          ; save seg 1 binding
.memcpy1
    ld      a,(ix+0)        ; n is the counter in the frame
    or      (ix+1)
    jr      z,memcpy3       ; on if copied n chars
    call    __far_page
    ld      a,(hl)          ; char from src
    push    af              ; Rabbit has no iyl: keep it on the stack over the page-in
    call    l_far_incptrs
    exx
    call    __far_page
    pop     af
    ld      (hl),a          ; place at dst
    call    l_far_incptrs
    exx
    ld      a,(ix+0)
    or      a
    jr      nz,memcpy2
    dec     (ix+1)
.memcpy2
    dec     (ix+0)
    jr      memcpy1
.memcpy3
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=dst
    pop     ix
    ld      d,0             ; the far pointer returned has d = 0 (__far_page leaves junk in it)
    ret
ELSE
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
ENDIF
