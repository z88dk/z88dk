;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly hand optimized by djm 1/3/99

        XLIB    strstrip

        INCLUDE "#z88_crt0.hdr"
        LIB     strcpy

.strstrip
; optimized set top on stack
        ld      hl,4
        add     hl,sp
        call    l_gint
        push    hl

;        push    bc
;        ld      hl,6
;        add     hl,sp
;        call    l_gint
;        pop     bc
;        push    hl
.i_3
;Get top int off stack optimized
        pop     hl
        push    hl
        ld      a,(hl)
        ld      hl,4
        add     hl,sp
        cp      (hl)
        jp      nz,i_4  ; !=
;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,6
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_eq
;        ld      a,h
;        or      l
;        jp      z,i_4
;Increment int at top of stack optimised (from ++)
        pop     hl
        inc     hl
        push    hl
; Removed surplus dec hl
;        dec     hl
        jp      i_3
.i_4
;Get top int off stack optimized
        pop     hl
        push    hl
        push    hl
        ld      hl,8
        add     hl,sp
        call    l_gint
        pop     de
        call    l_ne
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,6
        add     hl,sp
        call    l_gint
        push    hl
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    hl
        call    strcpy
        pop     bc
        pop     bc
.i_5
        ld      hl,6
        add     hl,sp
        call    l_gint
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
