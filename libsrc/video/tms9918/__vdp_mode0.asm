; We follow the MSX naming convention, so confusingly this is VDP mode 1 - 40x24

SECTION code_clib

PUBLIC  __vdp_mode0


; VDP map definitions
defc    COLOUR_TABLE      = $0000       ;Unused
defc    PATTERN_NAME      = $0000
defc    PATTERN_GENERATOR =  $800

defc    SPRITE_GENERATOR  = $0000       ;Unused
defc    SPRITE_ATTRIBUTE  = $0000


defc    COLUMNS = 40 

EXTERN  __tms9918_set_font
EXTERN  __tms9918_clear_vram
EXTERN  __tms9918_attribute
EXTERN  __tms9918_switch_mode
EXTERN  __tms9918_CAPS_MODE0
EXTERN  __tms9918_set_tables
EXTERN  __tms9918_setup_spec

EXTERN  FILVRM
EXTERN  VDPreg_Write


SECTION rodata_clib

; Specification of VDP mode 1
spec_mode0:
    defb     COLUMNS ;columsn
    defb     24      ;rows
    defb     80-1    ;Graphics w
    defb     48-1    ;Graphic h
    defb     0       ;Sprites not enabled
    defb     __tms9918_CAPS_MODE0  ; Console capabilities


; Table adderesses
mode0_addresses:
    defw    PATTERN_NAME
    defw    COLOUR_TABLE
    defb    $80             ;register 3
    defw    PATTERN_GENERATOR
    defb    $01             ;register 4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    $ff             ;endmarker


SECTION code_clib


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode0:
    push    af
    call    __tms9918_clear_vram
    pop     af

    ld      l,0         ;register 0:   -     -  -    -  -  - M2 EXTVID
    ld      h,$F0       ;register 1:   4/16K BL GINT M1 M3 - SI MAG
    call    __tms9918_switch_mode   ;Writes the appropriate registers (a = screenmode)

    ld      hl, mode0_addresses
    call    __tms9918_set_tables

    ; Set the screen colour
    ld      a,(__tms9918_attribute)
    ld      e,7
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.

    ld      hl,PATTERN_NAME
    ld      bc,1024
    ld      a,32
    call    FILVRM

    ; Set the font
    call    __tms9918_set_font

    ; Return our info block (cls is issued after return)
    ld      hl,spec_mode0
    call    __tms9918_setup_spec
    ret

