;
;

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_ioctl
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  RC700_DISPLAY
    EXTERN  CRT_FONT
    EXTERN  rc700_loadfont
    EXTERN  generic_console_font32


    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=0

    defc    GFXMODE = 132 ; GFXMODE

generic_console_ioctl:
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_mode
    ld      hl, bc
setup_font:
    ld      a, h
    or      l
    ld      (rc700_mode), a
    and     a
    ret     z 
    ld      b, 32
    ld      c, 96
    call    rc700_loadfont
    ld      a, GFXMODE
    ld      (RC700_DISPLAY),a
    and     a
    ret

check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, ioctl_failure
    ld      a, c
    ld      (rc700_mode), a
    call    setgfx
    and     a
    ret
    

ioctl_failure: 
    scf
generic_console_set_attribute:
    ret

generic_console_set_ink:
generic_console_set_paper:
    ret

generic_console_cls:
    ld      hl, RC700_DISPLAY
    ld      de, RC700_DISPLAY+1
    ld      bc, +(CONSOLE_COLUMNS*CONSOLE_ROWS)-1
    ld      (hl), 32
    ldir
    jp      setgfx

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    push    af
    call    xypos
    pop     af
    ld      (hl), a
    jp      setgfx


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld      a, (hl)
    and     a
    ret


xypos:
    ld      hl, RC700_DISPLAY
xypos_doit:
    ld      de, CONSOLE_COLUMNS
    and     a
    sbc     hl, de
    inc     b
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl, bc                      ;hl now points to address in display
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      hl, RC700_DISPLAY+CONSOLE_COLUMNS
    ld      de, RC700_DISPLAY
    ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-1))
    ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-2))
scrollup_doit:
    ldir
    ex      de, hl
    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    call    setgfx
    pop     bc
    pop     de
    ret

setgfx:
    ld      a, (rc700_mode)
    and     a
    ret     z
    ld      a,GFXMODE
    ld      (RC700_DISPLAY),a
    ret

    SECTION bss_clib

rc700_mode: 
    defb    0

    
    SECTION code_crt_init

    defc    DSPLC=$01                   ; RC700_DISPLAY CONTROL
    defc    DSPLD=$00                   ; RC700_DISPLAY DATA

; Disable the cursor (push off screen)
    ld      a, $80
    out     (DSPLC), a
    ld      a, 255
    out     (DSPLD), a                  ;X
    out     (DSPLD), a                  ;Y

    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    call    nz,setup_font
