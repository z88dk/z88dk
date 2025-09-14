;       CRT0 for the Mattel Aquarius
;
;       Stefano Bodrato Dec. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: aquarius_crt0.asm,v 1.21 2016-07-15 21:03:25 dom Exp $
;



    MODULE  aquarius_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    INCLUDE "target/aquarius/def/aqplus.def"

    INCLUDE "ioctl.def"

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    TAR__no_ansifont = 1
    PUBLIC  DISPLAY
    PUBLIC  CLIB_GENCON_CAPS
IF CLIB_AQUARIUS_PLUS = 1
    defc    CONSOLE_ROWS = 25
    defc    DISPLAY = $3000
    defc    CLIB_GENCON_CAPS=CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR
ELSE
    defc    CONSOLE_ROWS = 24
    defc    DISPLAY = $3028
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR 
ENDIF
    PUBLIC  COLOUR_MAP
    defc    COLOUR_MAP = DISPLAY + 1024
    defc    CONSOLE_COLUMNS = 40
    defc    __CPU_CLOCK = 4000000

    PUBLIC  CLIB_VIDEO_PAGE_PORT    ;Video paging port for aq+
    ; Page video into 0xc000 -> 0xffff
    defc    CLIB_VIDEO_PAGE_PORT = PORT_BANK3

    PUBLIC  CLIB_AQUARIUS_ROM
IFNDEF CLIB_AQUARIUS_ROM
    defc    CLIB_AQUARIUS_ROM = 0
ENDIF


    PUBLIC  CLIB_AQUARIUS_PLUS
IFNDEF CLIB_AQUARIUS_PLUS
    defc    CLIB_AQUARIUS_PLUS = 0

    ; Forcibly disable bitmap routines
    EXTERN  l_ret
    PUBLIC  cls_BITMAP
    PUBLIC  printc_BITMAP
    PUBLIC  scrollup_BITMAP
    PUBLIC  vpeek_BITMAP
    PUBLIC  generic_console_ioctl
    defc    cls_BITMAP = l_ret
    defc    printc_BITMAP = l_ret
    defc    scrollup_BITMAP = l_ret
    defc    vpeek_BITMAP = l_ret
    defc    generic_console_ioctl = l_ret
ENDIF

IF CLIB_AQUARIUS_ROM = 1
    INCLUDE	"target/aquarius/classic/rom.asm"
ELIF CLIB_AQUARIUS_PLUS = 1
    INCLUDE "target/aquarius/def/maths_mbf.def"
    INCLUDE	"target/aquarius/classic/aqplusram.asm"
ELSE
    INCLUDE "target/aquarius/def/maths_mbf.def"
    INCLUDE	"target/aquarius/classic/ram.asm"
ENDIF


l_dcal: 
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE	"crt/classic/crt_section.inc"

    SECTION code_crt_init
    ld      hl, DISPLAY
    ld      (base_graphics),hl

IF CLIB_AQUARIUS_PLUS = 1
    INCLUDE	"target/aquarius/classic/banks.asm"

  IF __HAVE_GENCON = 1
    SECTION code_crt_init
    EXTERN  set_default_palette
    EXTERN  generic_console_ioctl
    EXTERN  __aquarius_mode

    call    set_default_palette

    ; Remap the border color character for aqplus
    in      a, (IO_VCTRL)
    or      VCTRL_REMAP_BC
    ld      de, __aquarius_mode
    ld      (de), a
    ld      a, IOCTL_GENCON_SET_MODE
    ; This will setup the mode and screen size
    ; so that it matches the hardware during init.
    call    generic_console_ioctl
  ENDIF

ENDIF

    SECTION UNASSIGNED
    org     0

