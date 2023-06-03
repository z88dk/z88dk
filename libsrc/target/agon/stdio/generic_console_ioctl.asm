

    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"
    INCLUDE "target/agon/def/mos_api.inc"

    EXTERN  generic_console_cls
    EXTERN  __agon_putc
    EXTERN  asm_agon_setmode





; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de,hl
    ld      c,(hl)	;bc = where we point to
    inc     hl
    ld      b,(hl)
    cp      IOCTL_GENCON_SET_UDGS
    ld      e,128
    ld      d,128
    jr      z,set_font
    cp      IOCTL_GENCON_SET_FONT32
    ld      e,32
    ld      d,96
    jr      nz,check_mode
set_font:
    ld      hl,bc
font_loop:
    ld      a,23
    call    __agon_putc
    ld      a,e       ;character
    call    __agon_putc
    ld      b,8
charloop:
    ld      a,(hl)
    call    __agon_putc
    inc     hl
    djnz    charloop
    inc     e
    dec     d
    jr      nz,font_loop
    and     a
    ret
    
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure

    ; Set the mode
    ld      a,c
    call    asm_agon_setmode
    call    generic_console_cls
    and	    a
    ret
failure:
    scf
    ret

