;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function

        XLIB    scanf1

        INCLUDE "z88_crt0.hdr"
        LIB     sf_getc;
        LIB     sf_ungetc
        LIB     utoi
        LIB     isspace
	XREF	_sf_oldch

.scanf1
        ld      hl,-20
        add     hl,sp
        ld      sp,hl
;       _sf_oldch = char -1
        ld      a,-1
        ld      (_sf_oldch),a
        ld      hl,8
        add     hl,sp
; Optimized set int to 0
        ld      (hl),( 0 % 256)
        inc     hl
        ld      (hl),( 0 / 256)
        ld      hl,16
        add     hl,sp
        push    hl
        ld      hl,24
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        dec     hl
        pop     de
        call    l_pint
        inc     hl
        inc     hl
        call    l_gint
        pop     de
        call    l_pint
.i_3
        ld      hl,16
        add     hl,sp
        call    l_gint
; Optimized if (char) {
        ld      a,(hl)
        and     a
        jp      z,i_4
        ld      hl,16
        add     hl,sp
        call    l_gint
        ld      l,(hl)
        ld      h,0
        push    hl
        call    isspace
        pop     bc
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,16
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        jp      i_3
.i_5
        ld      hl,16
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
;push hl, ld hl,37 pop de optimized
        ld      de,37
        ex      de,hl
        call    l_ne
        ld      a,h
        or      l
        jp      z,i_6
        jp      i_3
.i_6
        ld      hl,16
        add     hl,sp
        call    l_gint
; Optimized char x == 42 jp z,i_7
        ld      a,(hl)
        cp      42
;       ld      hl,0
        jp      nz,i_7
        ld      hl,12
        add     hl,sp
        push    hl
        ld      hl,20
        add     hl,sp
        push    hl
        ld      hl,14
        add     hl,sp
        pop     de
        call    l_pint
        pop     de
        call    l_pint
        ld      hl,16
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        jp      i_8
.i_7
        ld      hl,12
        add     hl,sp
        push    hl
        ld      hl,20
        add     hl,sp
        push    hl
        ld      hl,26
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        dec     hl
        pop     de
        call    l_pint
        inc     hl
        inc     hl
        call    l_gint
        pop     de
        call    l_pint
        pop     de
        call    l_pint
.i_8
        ld      hl,16
        add     hl,sp
        push    hl
        call    l_gint
        push    hl
        ld      hl,20
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,12
        add     hl,sp
        push    hl
        call    utoi
        pop     bc
        pop     bc
        pop     de
        add     hl,de
        pop     de
        call    l_pint
        ld      hl,6
        add     hl,sp
        call    l_gint
        call    l_lneg
        ld      a,h
        or      l
        jp      z,i_9
        ld      hl,6
        add     hl,sp
;push hl, ld hl,32767 pop de optimized
        ld      de,32767
        ex      de,hl
        call    l_pint
.i_9
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,18
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
        pop     de
        ld      a,l
        ld      (de),a
        call    l_lneg
        ld      a,h
        or      l
        jp      z,i_10
        jp      i_4
.i_10
.i_11
        ld      hl,2
        add     hl,sp
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        push    hl
        call    sf_getc
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
        push    hl
        call    isspace
        pop     bc
        ld      a,h
        or      l
        jp      z,i_12
        jp      i_11
.i_12
        ld      hl,2
        add     hl,sp
; Optimized char x == -1 jp z,i_13
        ld      a,(hl)
        cp      -1
;       ld      hl,0
        jp      nz,i_13
        ld      hl,8
        add     hl,sp
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_14
        jp      i_4
        jp      i_15
.i_14
        ld      hl,-1
        exx
        ld      hl,20
        add     hl,sp
        ld      sp,hl
        exx
        ret


.i_15
.i_13
        ld      hl,2
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        push    hl
        call    sf_ungetc
        pop     bc
        ld      hl,0
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        jp      i_18
.i_19
        ld      hl,18
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        push    hl
        call    sf_getc
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
        jp      i_17
.i_20
.i_21
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
        inc     hl
        ld      a,h
        or      l
        jp      z,i_22
        ld      hl,18
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        push    hl
        call    sf_getc
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
;push hl, ld hl,-1 pop de optimized
        ld      de,-1
        ex      de,hl
        call    l_eq
        ld      a,h
        or      l
        jp      z,i_23
        jp      i_22
.i_23
        ld      hl,18
        add     hl,sp
        call    l_gint
        ld      l,(hl)
        ld      h,0
        push    hl
        call    isspace
        pop     bc
        ld      a,h
        or      l
        jp      z,i_24
        jp      i_22
.i_24
        ld      hl,18
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,12
        add     hl,sp
        pop     de
        call    l_ne
        ld      a,h
        or      l
        jp      z,i_25
        ld      hl,18
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
.i_25
        jp      i_21
.i_22
        ld      hl,18
        add     hl,sp
        call    l_gint
;push hl, ld hl,0 pop de optimized
        ld      de,0
        ex      de,hl
        ld      a,l
        ld      (de),a
        jp      i_17
.i_26
        ld      hl,0
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        jp      i_29
.i_30
        ld      hl,1
        add     hl,sp
;push hl, ld hl,10 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(10 % 256)
        ld      hl,3
        add     hl,sp
;push hl, ld hl,0 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(0 % 256)
        ld      hl,4
        add     hl,sp
;push hl, ld hl,3276 pop de optimized
        ld      de,3276
        ex      de,hl
        call    l_pint
        jp      i_28
.i_31
        ld      hl,1
        add     hl,sp
;push hl, ld hl,8 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(8 % 256)
        ld      hl,3
        add     hl,sp
;push hl, ld hl,1 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(1 % 256)
        ld      hl,4
        add     hl,sp
;push hl, ld hl,8191 pop de optimized
        ld      de,8191
        ex      de,hl
        call    l_pint
        jp      i_28
.i_32
        ld      hl,1
        add     hl,sp
;push hl, ld hl,10 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(10 % 256)
        ld      hl,3
        add     hl,sp
;push hl, ld hl,1 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(1 % 256)
        ld      hl,4
        add     hl,sp
;push hl, ld hl,6553 pop de optimized
        ld      de,6553
        ex      de,hl
        call    l_pint
        jp      i_28
.i_33
        ld      hl,1
        add     hl,sp
;push hl, ld hl,16 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(16 % 256)
        ld      hl,3
        add     hl,sp
;push hl, ld hl,1 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(1 % 256)
        ld      hl,4
        add     hl,sp
;push hl, ld hl,4095 pop de optimized
        ld      de,4095
        ex      de,hl
        call    l_pint
        jp      i_28
.i_34
        ld      hl,8
        add     hl,sp
        call    l_gint
        exx
        ld      hl,20
        add     hl,sp
        ld      sp,hl
        exx
        ret


        jp      i_28
.i_29
        call    l_case
        defw    i_30,100
        defw    i_31,111
        defw    i_32,117
        defw    i_33,120
        defw    0
        jp      i_34
.i_28
        ld      hl,12
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,16
        add     hl,sp
;push hl, ld hl,0 pop de optimized
        ld      de,0
        ex      de,hl
        call    l_pint
        pop     de
        call    l_pint
.i_35
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
        inc     hl
        ld      a,h
        or      l
        jp      z,i_37
        ld      hl,2
        add     hl,sp
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        push    hl
        call    sf_getc
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
        push    hl
        call    isspace
        pop     bc
        call    l_lneg
        ld      a,h
        or      l
        jp      z,i_37
        ld      hl,2
        add     hl,sp
; Optimized char x != -1 jp z,i_37
        ld      a,(hl)
        cp      -1
;       ld      hl,0
        jp      z,i_37
        ld      hl,1
        jp      i_38
.i_37
        ld      hl,0
.i_38
        ld      a,h
        or      l
        jp      z,i_36
        ld      hl,3
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        call    l_lneg
        ld      a,h
        or      l
        jp      z,i_39
        ld      hl,2
        add     hl,sp
; Optimized char x == 45 jp z,i_40
        ld      a,(hl)
        cp      45
;       ld      hl,0
        jp      nz,i_40
        ld      hl,3
        add     hl,sp
;push hl, ld hl,-1 pop de optimized
        ld      de,-1
        ex      de,hl
        ld      a,l
        ld      (de),a
        jp      i_35
        jp      i_41
.i_40
        ld      hl,3
        add     hl,sp
;push hl, ld hl,1 pop de optimized
        ld      de,1
        ex      de,hl
        ld      a,l
        ld      (de),a
.i_41
.i_39
        ld      hl,2
        add     hl,sp
; Optimized if ( uchar < 48 )  (only if char isn't used) (ugly)
        ld      a,(hl)
        cp      48
        jp      z,i_42
        jp      nc,i_42
        ld      hl,8
        add     hl,sp
        call    l_gint
        exx
        ld      hl,20
        add     hl,sp
        ld      sp,hl
        exx
        ret


.i_42
        ld      hl,2
        add     hl,sp
; optimized ( uchar >= 97 ) (only if char not used)
        ld      a,(hl)
        cp      97
        jr      z,ASMPC+5
        jp      c,i_43
        ld      hl,2
        add     hl,sp
; Optimized add -87 to unsigned char
        ld      a,(hl)
        add     a,-87
        ld      (hl),a
        jp      i_44
.i_43
        ld      hl,2
        add     hl,sp
; optimized ( uchar >= 65 ) (only if char not used)
        ld      a,(hl)
        cp      65
        jr      z,ASMPC+5
        jp      c,i_45
        ld      hl,2
        add     hl,sp
; Optimized add -55 to unsigned char
        ld      a,(hl)
        add     a,-55
        ld      (hl),a
        jp      i_46
.i_45
        ld      hl,2
        add     hl,sp
; Optimized add -48 to unsigned char
        ld      a,(hl)
        add     a,-48
        ld      (hl),a
.i_46
.i_44
        ld      hl,2
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        push    hl
        ld      hl,3
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        pop     de
        call    l_uge
        ld      a,h
        or      l
        jp      nz,i_48
        ld      hl,14
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,6
        add     hl,sp
        call    l_gint
        pop     de
        call    l_ugt
        ld      a,h
        or      l
        jp      nz,i_48
        ld      hl,0
        jp      i_49
.i_48
        ld      hl,1
.i_49
        ld      a,h
        or      l
        jp      z,i_47
        ld      hl,8
        add     hl,sp
        call    l_gint
        exx
        ld      hl,20
        add     hl,sp
        ld      sp,hl
        exx
        ret


.i_47
        ld      hl,14
        add     hl,sp
        push    hl
        ld      hl,16
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,5
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        pop     de
        call    l_mult
        push    hl
        ld      hl,6
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        pop     de
        add     hl,de
        pop     de
        call    l_pint
        jp      i_35
.i_36
        ld      hl,12
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,5
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        push    hl
        ld      hl,18
        add     hl,sp
        call    l_gint
        pop     de
        call    l_mult
        pop     de
        call    l_pint
        jp      i_17
.i_18
        call    l_case
        defw    i_19,99
        defw    i_20,115
        defw    0
        jp      i_26
.i_17
        ld      hl,8
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        jp      i_3
.i_4
        ld      hl,8
        add     hl,sp
        call    l_gint
        exx
        ld      hl,20
        add     hl,sp
        ld      sp,hl
        exx
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
