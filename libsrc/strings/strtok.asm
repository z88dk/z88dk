;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly hand optimized by djm 1/3/99

        XLIB    strtok

        INCLUDE "#z88_crt0.hdr"
        LIB     strchr
        LIB     strspn
        LIB     strcspn

.strtok
        ld      hl,4
        add     hl,sp
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_3
; hl is already = (sp+4), so can delete this surplus code
;        ld      hl,4
;        add     hl,sp
;        call    l_gint
        ld      (smc_st_strtok_t),hl
        jp      i_4
.i_3
        ld      hl,4
        add     hl,sp
;push hl, ld hl,(smc_st_strtok_t) pop de optimized
        ld      de,(smc_st_strtok_t)
        ex      de,hl
        call    l_pint
.i_4
        ld      hl,4
        add     hl,sp
        push    hl
        call    l_gint
        push    hl
        ld      hl,8
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,8
        add     hl,sp
        call    l_gint
        push    hl
        call    strspn
        pop     bc
        pop     bc
        pop     de
        add     hl,de
        pop     de
        call    l_pint
        ld      hl,4
        add     hl,sp
        call    l_gint
        ld      l,(hl)
        ld      h,0
        ld      a,h
        or      l
        ret     z
; At this point hl is already = 0
;        jp      nz,i_5
;        ld      hl,0
;        ret


.i_5
        ld      hl,4
        add     hl,sp
        call    l_gint
;ld (smc_st_strtok_t),hl;ld hl,(smc_st_strtok_t)
        ld      (smc_st_strtok_t),hl
        push    hl
        ld      hl,6
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,6
        add     hl,sp
        call    l_gint
        push    hl
        call    strcspn
        pop     bc
        pop     bc
        pop     de
        add     hl,de
;ld (smc_st_strtok_t),hl;ld hl,(smc_st_strtok_t)
        ld      (smc_st_strtok_t),hl
        ld      a,(hl)
        and     a
        jp      z,i_6

;        ld      l,(hl)
;        ld      h,0
;        ld      a,h
;        or      l
;        jp      z,i_6
        ld      hl,(smc_st_strtok_t)
        inc     hl
        ld      (smc_st_strtok_t),hl
        dec     hl
;This bit of code basically sets a char equal to 0
        ld      (hl),0
;push hl, ld hl,0 pop de optimized
;        ld      de,0
;        ex      de,hl
;        ld      a,l
;        ld      (de),a
.i_6
        ld      hl,4
        add     hl,sp
;Removing ret following call l_gint
        jp      l_gint




; --- Start of Static Variables ---

.smc_st_strtok_t        defs    2

; --- End of Compilation ---
