;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Slightly strong hand optimization by djm 1/3/99
;
;	$Id: stricmp.asm,v 1.2 2001-04-11 12:15:32 dom Exp $

        XLIB    stricmp

        INCLUDE "#z88_crt0.hdr"
        LIB     tolower

.stricmp
        push    bc
.i_5
        ld      hl,1
        add     hl,sp
        push    hl
        ld      hl,8
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
        push    hl
        call    tolower
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
        push    hl
        call    tolower
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
.i_3
        ld      hl,1
        add     hl,sp
        ld      a,(hl)
        and     a
        jp      z,i_6

;        ld      l,(hl)
;        ld      h,0
;        ld      a,h
;        or      l
;        jp      z,i_6

;at this point hl = c1 (sp+1) & a = *c1, so we don't need this bit
        dec     hl
        cp      (hl)
        jp      nz,i_6  ; c1 != c2

;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,2
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_eq
;        ld      a,h
;        or      l
;        jp      z,i_6

        ld      hl,1
        jp      i_7
.i_6
        ld      hl,0
.i_7
        ld      a,h
        or      l
        jp      nz,i_5
;        jp      z,i_4
;        jp      i_5
.i_4
        ld      hl,1
        add     hl,sp 
; Now, we have to calculate c1-c2
        ld      a,(hl)
        dec     hl
        sub     (hl)
        ld      l,a
        ld      h,0
        pop     bc
        ret

;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,2
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_sub
;        pop     bc
;        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
