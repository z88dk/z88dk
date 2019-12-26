
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"

    EXTERN  generic_console_cls
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  asm_load_charset
    EXTERN  __x1_mode
    EXTERN  __x1_pcg_mode
    EXTERN  __console_w

    EXTERN  set_crtc_10
    INCLUDE "target/mc1000/def/mc1000.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS


; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de,hl
    ld      c,(hl)	;bc = where we point to
    inc     hl
    ld      b,(hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz,check_set_udg
    ld      (generic_console_font32),bc
    ld      l,c
    ld      h,b
    ld      b,96
    ld      c,32
    ld      e,1
    call    set_pcg_chars
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz,check_mode
    ld      (generic_console_udg32),bc
    ld      l,c
    ld      h,b
    ld      b,128
    ld      c,128
    ld      e,2
    call    set_pcg_chars
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure
    ld      a,c
    ld      c,$f0
    ld      de,$1928		;rows cols
    ld      hl,text40
    and     a
    jr      z,set_mode
    ld      c,$b0
    ld      de,$1950
    ld      hl,text80
    cp      1
    jr      nz,failure
set_mode:
    push    bc
    ld      (__x1_mode),a
    ld      (__console_w),de
    call    set_crtc_10
    pop     de
    ld      bc,$1a03
    ld      a,$82
    out     (c),a
    dec     bc
    out     (c),e
    call    generic_console_cls
    jr      success
failure:
    scf
dummy_return:
    ret


set_pcg_chars:
    ld      a,h
    or      l
    jr      z,clear_mode
    ld      a,(__x1_pcg_mode)
    or      e
    ld      (__x1_pcg_mode),a
    call    asm_load_charset
    ret
clear_mode:
    ld      a,e
    cpl
    ld      hl,__x1_pcg_mode
    and     (hl)
    ld      (hl),a
    ret



    SECTION	rodata_clib

text40:	defb 37h, 28h, 2Dh, 34h, 1Fh, 02h, 19h, 1Ch, 00h, 07h
text80:	defb 6Fh, 50h, 59h, 38h, 1Fh, 02h, 19h, 1Ch, 00h, 07h

