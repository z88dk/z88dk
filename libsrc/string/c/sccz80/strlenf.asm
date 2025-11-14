; strlen function for use with far pointers
; 31/3/00 GWL

;
; $Id: strlen_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start    ;Get the initial bindings
    EXTERN __far_end   ;Reset to initial bindings
    EXTERN __far_page    ;Page in the far segment
    EXTERN l_far_incptrs  ;Increment a far pointer (returning near address)
    PUBLIC strlenf
    PUBLIC _strlenf


;int strlen(far *s)
; finds length of s

.strlenf
._strlenf
    pop     hl
    pop     bc
    pop     de      ; EBC=far pointer
    push    de
    push    bc
    push    hl
    push    ix
    call    __far_start
    ex      af,af'  ; save seg 1 binding
    ld      ix,0    ; our counter
    call    __far_page
.strlen1
    ld      a,(hl)  ; check for string end
    and     a
    jr      z,strlenend
    inc     ix      ; increment counter
    call    l_far_incptrs
    jr      strlen1
.strlenend
    ex      af,af'
    call    __far_end
    push    ix
    pop     hl      ; HL=length
    pop     ix
    ret
ENDIF