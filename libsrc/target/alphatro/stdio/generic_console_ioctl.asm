
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"
    INCLUDE "target/alphatro/def/alphatro.def"

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE


; a = ioctl
; de = arg
    generic_console_ioctl:
    ex      de,hl
    ld      c,(hl)	;bc = where we point to
    inc     hl
    ld      b,(hl)
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure
    ld      a,c		; The mode
    ld      l,40		; columns
    ld      de,TAB1
    and     a
    jr      z,set_mode
    ld      l,80
    ld      de,TAB2
    cp      1
    jr      nz,failure
set_mode:
    ld      a,l
    ld      (__console_w),a
    ex      de,hl
    call    switch_mode
    call    generic_console_cls
    and	    a
    ret
failure:
    scf
    ret


; hl = crt table
switch_mode:
    LD      B,10H
    LD      C,00H
CTSET1: 
    LD      A,C
    OUT     (CRTPT0),A
    LD      A,(hl)
    OUT     (CRTPT1),A
    INC     C
    INC     hl
    DJNZ    CTSET1
    ret



    SECTION rodata_clib
TAB1:
    DB      46H,28H,34H,56H ;40X24
    DB      1EH,02H,18H,1BH
    DB      0,09H,20H,09H
    DB      0,0,0,0

TAB2:
    DB      7EH,50H,5FH,5CH ;80X24
    DB      1EH,04H,18H,1BH
    DB      0,09H,20H,09H
    DB      0,0,0,0
