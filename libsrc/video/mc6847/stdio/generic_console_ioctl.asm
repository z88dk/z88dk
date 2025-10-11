
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_driver

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  __mc6847_mode
    EXTERN  __mc6847_modeval
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __tms9918_console_ioctl

    INCLUDE "video/mc6847/mc6847.inc"
    INCLUDE "ioctl.def"

    EXTERN  generic_console_caps
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAPS_TEXT

        ; Text
IF FORpc6001 | FORspc1000
    defc    CAPS_TEXT = CAP_GENCON_INVERSE|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR
ELIF FORvz
    defc    CAPS_TEXT = CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR
ELIF FORphc25
    defc    CAPS_TEXT = CAP_GENCON_INVERSE
ELIF FORfc100
    defc    CAPS_TEXT = CAP_GENCON_INVERSE
ELSE
    defc    CAPS_TEXT = 0
ENDIF
        ; Hires
    defc    CAPS_HIRES=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE
        ; Colour
    defc    CAPS_MULTICOLOUR=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_BOLD


IFDEF MC6847_NO_IOCTL
; phc20 only has text mode, no point doing anything here
generic_console_ioctl:
    scf
    ret

ELSE
; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      (generic_console_font32), bc
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_mode
    ld      (generic_console_udg32), bc
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a, c                        ; The mode
    and     31

    ;; Text mode
    ld      hl, +( (MODE_TEXT << 8) + CAPS_TEXT)
    ld      de, $1020       ;16 rows, 32 columns
    and     a
    jr      z, set_mode

IF FORvz
    ;; On +vz, Mode1=MULTICOLOUR
    ld      h, MODE_MULTICOLOUR
    ld      l, CAPS_MULTICOLOUR
    ld      de, $0810   ;8 rows, 16 columns
    set     1,c
    res     0,c
    cp      1
    jr      z,set_mode
    cp      2
    jr      nz, failure
    ;; Fall throught into set_mode
ELSE
  IF MC6847_HAS_HIRES
    ;; HIRES MODE
    ld      hl, +( (MODE_HIRES << 8) + CAPS_HIRES)
    IF FORsv8000
        ld      de, $0c20       ;12 rows, 32 columns
    ELSE
        ld      de, $1820       ;24 rows, 32 columns
    ENDIF
    cp      1                           ;HIRES
    jr      z, set_mode
  ENDIF

  IF MC6847_HAS_CG
    ;; MULTICOLOUR MODE
    ld      hl, +( (MODE_MULTICOLOUR << 8) + CAPS_MULTICOLOUR)
    IF FORsv8000
        ld      de, $0c10       ;12 rows, 16 columns
    ELSE
        ld      de, $1810       ;24 rows, 16 columns
    ENDIF
    cp      2                           ;Half hires/multicolour
    IF FORspc1000
        jr      z,set_mode
        cp      10                          ;Switch to VDP
        jr      c, failure
        ld      c, a
        ld      a, 10
        ld      (__mc6847_mode), a
        ld      a, 24
        ld      (__console_h), a
        ld      a, c
        sub     10
        ld      l, a
        ld      h, 0
        push    hl
        ld      hl, 0
        add     hl, sp
        ex      de, hl
        ld      a, IOCTL_GENCON_SET_MODE
        call    __tms9918_console_ioctl
        pop     hl
        jr      success
    ELSE
        jr      nz, failure
    ENDIF
  ENDIF
ENDIF
set_mode:
    bit     5, c
    jr      z, not_css
IF FORphc25
    set     6,h
ELSE
    ld      a,h
    xor     2
    ld      h,a
ENDIF
not_css:
    ld      a, e
    ld      (__console_w), a
    ld      a, d
    ld      (__console_h), a
    ld      a, l
    ld      (generic_console_caps), a
    ld      a, c
    and     31              ;Remove the CSS setting flag
    ld      (__mc6847_mode), a
    ld      a,h             ;Hardware value
    ld      (__mc6847_modeval),a
    IF  FORmc1000
        ld      (__mc6847_modeval),a
        out     ($80), a
        ld      ($f5), a                    ;Keep basic up-to-date with mode
        ld      hl, dummy_return
        ld      ($f7), hl                   ; cursor flashing and positioning routine
    ELIF FORpc6001
        ;; MC6847 registers are memory mapped as first byte
        ld      hl,(SYSVAR_screen-1)
        ld      l,0
        ld      (hl),a
    ELIF FORsv8000
        out     ($c0), a
    ELIF FORvz
        ld      ($783b), a                  ;SYS VAR
        ld      ($6800), a                  ;Latch
    ELIF FORspc1000
        ld      bc, $2000
        out     (c), a
    ELIF FORphc25
        ld      c,a
        in      a,($40)
        and     @00001111
        or      c
        out     ($40),a
    ENDIF
    call    generic_console_cls
    and     a
    ret
failure:
    scf
dummy_return:
    ret
ENDIF