
; Macro file to help harmonise code

; Support a 8x4 font
; defc MC6857_SUPPORT_8x4_FONT = 1

IF FORphc25
    INCLUDE "target/phc25/def/phc25.def"
    defc    MC6847_HAS_HIRES = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MODE0_3x2 = 1
    defc    MC6847_HIRES_YRES = 192
ENDIF


IF FORphc20
    INCLUDE "target/phc25/def/phc25.def"
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MODE0_1x1 = 1
    defc    MC6847_HIRES_YRES = 0
    defc    MC6847_NO_IOCTL = 1
ENDIF

IF FORfc100
    INCLUDE "target/fc100/def/fc100.def"
    defc    MC6847_HAS_HIRES = 0
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MODE0_3x2 = 1
    defc    MC6847_HIRES_YRES = 0
    defc    MC6847_NO_IOCTL = 1 
ENDIF

IF FORsv8000
    INCLUDE "target/sv8000/def/sv8000.def"
    defc    MODE0_1x1 = 1
    defc    MC6847_HAS_HIRES = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MC6847_HIRES_YRES = 96
ENDIF

IF FORmc1000
    INCLUDE "target/mc1000/def/mc1000.def"
    defc    MC6847_HAS_HIRES = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HIRES_YRES = 192
ENDIF

IF FORvz
    INCLUDE "target/vz/def/vz.def"
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HIRES_YRES = 64
ENDIF


IF FORpc6001
    INCLUDE "target/pc6001/def/pc6001.def"
    defc    MODE0_3x2 = 1
    defc    MC6847_HAS_HIRES = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MC6847_HIRES_YRES = 192
ENDIF

IF FORspc1000
    ; SPC1000 uses I/O space
    defc DISPLAY = 0
    defc MC6847_IOSPACE = 1
    defc    MC6847_HAS_HIRES = 1
    defc    MC6847_HAS_CG = 1
    defc    MC6847_HAS_TEXT_GFX = 1
    defc    MODE0_3x2 = 1
    defc    MC6847_HIRES_YRES = 192
    INCLUDE "target/spc1000/def/spc1000.def"
ENDIF


; Default size of the text screen
defc MC6847_CONSOLE_COLUMNS = 32
defc MC6847_CONSOLE_ROWS = 16


MACRO GETSCREENADDRESS
    IF FORpc6001
        ld      hl,(SYSVAR_screen-1)
        ld      l,0
        inc     h
        inc     h
    ELSE
        ld      hl,DISPLAY
    ENDIF
ENDM


MACRO GETSCREENADDRESS_bc
    IF FORpc6001
        ld      bc,(SYSVAR_screen-1)
        ld      c,0
        inc     b
        inc     b
    ELSE
        ld      bc,DISPLAY
    ENDIF
ENDM

MACRO GETSCREENADDRESS_de
    IF FORpc6001
        ld      de,(SYSVAR_screen-1)
        ld      e,0
        inc     d
        inc     d
    ELSE
        ld      de,DISPLAY
    ENDIF
ENDM






