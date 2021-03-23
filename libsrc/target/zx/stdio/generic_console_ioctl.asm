
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_driver
    INCLUDE "ioctl.def"

    EXTERN  generic_console_cls
    EXTERN  __zx_32col_font
    EXTERN  __zx_64col_font
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_screenmode
    EXTERN  __console_w
    EXTERN  __zx_mode0_console_w

    EXTERN  asm_sam_set_screenmode
    EXTERN  asm_zxn_copytiles
    EXTERN  generic_console_caps


    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_INVERSE | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR
    defc    CLIB_GENCON_CAPS_TIMEX_HIRES = CAP_GENCON_INVERSE | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS
    defc    CLIB_GENCON_CAPS_TILEMAP =  CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR

; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de,hl
    ld      c,(hl)    ;bc = where we point to
    inc     hl
    ld      b,(hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz,check_set_font64
    ld      (__zx_32col_font),bc
IF FORzxn
    ld      de,$6020
ENDIF
font_success:
IF FORzxn
    ld      a,(__zx_screenmode)
    bit     6,a
    jr      z,success
    ; Copy the font into the tileset
    ld      l,c
    ld      h,b
    ld      c,e
    ld      b,d
    call    asm_zxn_copytiles
ENDIF
success:
    and     a
    ret
check_set_font64:
    cp      IOCTL_GENCON_SET_FONT64
    jr      nz,check_set_udg
    ld      (__zx_64col_font),bc
    jr      success
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz,check_mode
    ld      (__zx_32col_udgs),bc
    ld      de,$8080
    jr      font_success
check_mode:
IF FORsam
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure
    ld      a,c
    ; 1 = mode 1 (ZX)
    ; 2 = mode 2 (hi colour)
    ; 3 = mode 3 (wide)
    ; 4 = mode 4 (very high colour)
    and     a
    jr      z,failure
    cp      5
    jr      nc,failure
    call    asm_sam_set_screenmode
    ld      a,CLIB_GENCON_CAPS
    ld      (generic_console_caps),a
    call    generic_console_cls
    jr      success
ELIF FORts2068 | FORzxn
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure
    ld      a,(__zx_mode0_console_w)
    ld      l,a
    ld      a,c
    ; 0 = screen 0
    ; 1 = screen 1
    ; 2 = high colour
    ; 6 = hires
    ld      h,CLIB_GENCON_CAPS
    cp      0
    jr      z,set_mode
    cp      1
    jr      z,set_mode
    cp      2
    jr      z,set_mode
    and     7
    sla     l
    cp      6
    ld      h,CLIB_GENCON_CAPS_TIMEX_HIRES
  IF !FORzxn
    jr      nz,failure
  ELSE
    jr      z,set_mode
;zxn modes
    ld      a,c
    ld      (__zx_screenmode),a
    ; Mode 64 = 40 column
    ;      65 = 40 column with single byte tiles
    ;      66 = 80 column
    ;      67 = 80 column with single byte tiles
    rrca
    rrca
    rrca
    and     @01100000
    or      @10000001
    nextreg $6b,a
    nextreg $6c,@10000000
    nextreg $6e,$6c ;tile map
    nextreg $6f,$4c    ;tile definition
    ld      hl,$2028
    bit     6,a
    jr      z,set_tilemap_size
    ld      l,80
set_tilemap_size:
    ld      (__console_w),hl
    ld      a,CLIB_GENCON_CAPS_TILEMAP
    ld      (generic_console_caps),a
    call    generic_console_cls
    jr      success
  ENDIF
set_mode:
    ld      (__zx_screenmode),a
    ld      a,h
    ld      (generic_console_caps),a
    ld      h,$18		;Console height
    ld      (__console_w),hl
    in      a,($ff)
    and     @1100000
    ld      b,a
    ld      a,c
    and     @00111111
    or      b
    out     ($ff),a
    call    generic_console_cls
    jp      success
ENDIF
failure:
    scf
    ret
