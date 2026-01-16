

        MODULE  generic_console_ioctl
        PUBLIC  generic_console_ioctl

        SECTION code_clib
        INCLUDE "ioctl.def"
        INCLUDE "target/aquarius/def/aqplus.def"

        EXTERN  generic_console_cls
        EXTERN  __aquarius_mode
        EXTERN  __aquarius_video_base
        EXTERN  __aquarius_pcg_pagein
        EXTERN  __aquarius_video_pagein
        EXTERN  __aquarius_video_pageout

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  generic_console_caps

        EXTERN  CLIB_AQUARIUS_PLUS
        EXTERN  CLIB_VIDEO_PAGE_PORT

        EXTERN  __console_h
        EXTERN  __console_w


        ; For AQ+ we have different values
        EXTERN  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS_TEXT=CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS_BITMAP=CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_INVERSE|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE


; a = ioctl
; de = arg
generic_console_ioctl:
        ; Check to see if we're meant to suppport AQ+
        ld      c, CLIB_AQUARIUS_PLUS
        rr      c
        ccf
        ret     c

        ex      de, hl
        ld      e, (hl)                 ;de = where we point to
        inc     hl
        ld      d, (hl)
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz, ck_font
        ld      (generic_console_udg32), de
        call    __aquarius_pcg_pagein
        ld      hl, (__aquarius_video_base)
        ld      bc, 128*8
        add     hl, bc
        ex      de, hl
        ldir
        call    __aquarius_video_pageout
        and     a
        ret
ck_font:
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz, ck_mode
        ld      (generic_console_font32), de
        call    __aquarius_pcg_pagein
        ld      hl, (__aquarius_video_base)
        ld      bc, 32*8
        add     hl, bc
        ld      bc, 96*8
        ex      de, hl
        ldir
        call    __aquarius_video_pageout
success:
        and     a
        ret


ck_mode:
        cp      IOCTL_GENCON_SET_MODE
        jr      nz, failure
        ld      a, e
        ; VCTRL_MODE_OFF             = (0 << 1),
        ; VCTRL_TEXT_ENABLE          = (1 << 0),
        ; VCTRL_MODE_TILEMAP         = (1 << 1),
        ; VCTRL_MODE_BITMAP (1bpp)   = (2 << 1),
        ; VCTRL_MODE_MC (4bpp)       = (3 << 1),
        ; VCTRL_SPRITES_ENABLE       = (1 << 3),
        ; VCTRL_TEXT_PRIORITY        = (1 << 4),
        ; 1 = mode 0  = text 40x25
        ; 2 = mode 1  = 64x32 tilemap
        ; 3 = mode 2  = hires 320x200 1bpp
        ; 4 = mode 3  = lores 160x200 4bpp
        ; +8   = sprites enable
        ; +16  = text priority
        ; +32  = remap border color
        ; +64  = 80 column text mode
        ; +128 = select 2nd text page
        ;
        ; If text is enabled, we preferentially print to there
        ;

        ld      (__aquarius_mode), a
        out     (PORT_VCTRL), a

        ld      b, a
        bit     6, a
        ld      a, 40
        jr      z, setWidth
        ld      a, 80
setWidth:
        ld      (__console_w), a
        ld      a, b

        ld      c, CLIB_GENCON_CAPS_TEXT
        bit     0, a
        jr      nz, set_caps
        ld      c, CLIB_GENCON_CAPS_BITMAP
set_caps:
        ld      a, 25
        ld      (__console_h), a
        ld      a, c
        ld      (generic_console_caps), a
        call    generic_console_cls
        and     a
        ret
failure:
        scf
        ret

