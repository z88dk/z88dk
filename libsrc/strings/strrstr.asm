;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly hand optimized by djm 1/3/99
;
;	$Id: strrstr.asm,v 1.3 2001-09-10 16:08:33 stefano Exp $

        XLIB    strrstr

        INCLUDE "#z80_crt0.hdr"
        LIB     strlen
        LIB     strncmp

.strrstr
        dec     sp
        push    bc
        push    bc
        ld      hl,2
        add     hl,sp
        push    hl
        ld      hl,9
        add     hl,sp
        call    l_gint
;Optimized copy of char
        ld      a,(hl)
        pop     de
        ld      (de),a
        ld      hl,7
        add     hl,sp
        call    l_gint
        push    hl
        call    strlen
        pop     bc
        pop     bc
        push    hl
        ld      hl,3
        add     hl,sp
        push    hl
        ld      hl,11
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,13
        add     hl,sp
        call    l_gint
        push    hl
        call    strlen
        pop     bc
        pop     de
        add     hl,de
        push    hl
        ld      hl,4
        add     hl,sp
        call    l_gint
        pop     de
        call    l_sub
        pop     de
        call    l_pint
.i_5
        ld      hl,3
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,11
        add     hl,sp
        call    l_gint
        pop     de
        call    l_uge
        ld      a,h
        or      l
        jp      z,i_4
        jp      i_6
.i_3
        ld      hl,3
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
; Removed surplus inc hl
;        inc     hl
        jp      i_5
.i_6
        ld      hl,3
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        dec     hl
        cp      (hl)
        jp      nz,i_3


;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,4
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_eq
;        ld      a,h
;        or      l
;        jp      z,i_7  ; this jumps back to i_3
        ld      hl,3
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,9
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,4
        add     hl,sp
        call    l_gint
        push    hl
        call    strncmp
        pop     bc
        pop     bc
        pop     bc
        ld      a,h
        or      l
        jp      nz,i_3
        ld      hl,3
        add     hl,sp
        call    l_gint
        inc     sp
        pop     bc
        pop     bc
        ret


;.i_8
;.i_7
;        jp      i_3

.i_4
        ld      hl,0
        inc     sp
        pop     bc
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
