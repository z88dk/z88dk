; strrchr function for use with far pointers
; 31/3/00 GWL

;
; $Id: strrchr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strrchrf
    PUBLIC _strrchrf

;far *strrchr(far *s,int c)
; finds pointer to last occurrence of c in s (or NULL if not found)

.strrchrf
._strrchrf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    ld      ix,4            ; +2 pushed IX +2 return address
    add     ix,sp
    ld      e,0
    ld      h,e
    ld      l,e
    exx                     ; E'H'L'=NULL pointer, if char not found
    ld      a,(ix+0)        ; A = char
    ld      c,(ix+2)
    ld      b,(ix+3)        ; BC = far offset
    ld      e,(ix+4)        ; EBC = far pointer
    ld      ixl,a           ; IXl = char (survives far calls + exx; IXh don't-care)
    call    __far_start
    ex      af,af'
    call    __far_page
.strrchr1
    ld      a,(hl)
    cp      ixl
    jr      nz,strrchr2	; on if not found character
    push    bc
    push    de
    exx
    pop     de
    pop     hl  ; store position of occurrence (EHL)
    exx
.strrchr2
    call    l_far_incptrs
    and     a
    jr      nz,strrchr1
    exx             ; EHL=pointer to last, or NULL
    ex      af,af'
    call    __far_end
    pop     ix              ; restore caller's IX
    ret
ENDIF
