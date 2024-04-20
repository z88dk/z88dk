; strrchr function for use with far pointers
; 31/3/00 GWL

;
; $Id: strrchr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    EXTERN __far_init    ;Get the initial bindings
    EXTERN __far_reset   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN __far_incptr  ;Increment a far pointer (returning near address)
    PUBLIC strrchrf
    PUBLIC _strrchrf

;far *strrchr(far *s,int c)
; finds pointer to last occurrence of c in s (or NULL if not found)

.strrchrf
._strrchrf
    ld      e,0
    ld      h,e
    ld      l,e
    exx         ; E'H'L'=NULL pointer, if char not found
    pop     hl
    pop     iy  ; IYl=char
    pop     bc
    pop     de  ; EBC=far pointer
    push    de
    push    bc
    push    iy
    push    hl
    call    __far_init
    ex      af,af'
    call    __far_page
.strrchr1
    ld      a,(hl)
    cp      iyl
    jr      nz,strrchr2	; on if not found character
    push    bc
    push    de
    exx
    pop     de
    pop     hl  ; store position of occurrence (EHL)
    exx
.strrchr2
    call    __far_incptr
    and     a
    jr      nz,strrchr1
    exx             ; EHL=pointer to last, or NULL
    ex      af,af'
    call    __far_reset
    ret
ENDIF
