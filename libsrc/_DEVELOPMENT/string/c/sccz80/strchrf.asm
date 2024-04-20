; strchr function for use with far pointers
; 31/3/00 GWL

;
; $Id: strchr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__
    SECTION   code_clib
    EXTERN __far_init    ;Get the initial bindings
    EXTERN __far_reset   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN __far_incptr  ;Increment a far pointer (returning near address)
    PUBLIC strchrf
    PUBLIC _strchrf



;far *strchr(far *s,int c)
; finds pointer to first occurrence of c in s (or NULL if not found)

.strchrf
._strchrf
    pop     hl
    pop     iy      ; IYl=char
    pop     bc
    pop     de      ; EBC=far pointer
    push    de
    push    bc
    push    iy
    push    hl	
    call    __far_init
    ex      af,af'  ; save seg 1 binding
    call    __far_page
.strchr1
    ld      a,(hl)
    cp      iyl
    jr      z,strchrend	; finished if found character
    call    __far_incptr
    and     a
    jr      nz,strchr1
    ld      e,a
    ld      b,a
    ld      c,a		; EBC=NULL, character not found
.strchrend
    ld      h,b
    ld      l,c		; EHL=pointer to character, or NULL
    ex      af,af'
    call    __far_reset
    ret
ENDIF
