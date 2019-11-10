
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"

    EXTERN  generic_console_cls
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __x1_mode
    EXTERN  __console_w

    EXTERN  set_crtc_10
	INCLUDE "target/mc1000/def/mc1000.def"


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
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz,check_mode
    ld      (generic_console_udg32),bc
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
            LD      BC,1A03H
        LD      A,82H
        OUT     (C),A
        DEC     BC
        out (c),e

;    ld      a,c
;    ld      bc,$1fd0	;X1Turbo flag - not sure what this value does
;    out     (c),a
    call    generic_console_cls
    jr      success
failure:
    scf
dummy_return:
    ret

	SECTION	rodata_clib

text40:	defb 37h, 28h, 2Dh, 34h, 1Fh, 02h, 19h, 1Ch, 00h, 07h
text80:	defb 6Fh, 50h, 59h, 38h, 1Fh, 02h, 19h, 1Ch, 00h, 07h

