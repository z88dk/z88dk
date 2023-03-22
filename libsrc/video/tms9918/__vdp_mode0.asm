; We follow the MSX naming convention, so confusingly this is VDP mode 1 - 40x24

SECTION code_video_vdp

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
EXTERN  __tms9918_CAPS_MODE0
EXTERN  __tms9918_set_tables

EXTERN  FILVRM
EXTERN  VDPreg_Write


SECTION rodata_video_vdp


; Table adderesses
mode0_addresses:
    defb    COLUMNS         ;text columns
    defb    24              ;text rows
    defb    80-1            ;graphics w
    defb    48-1            ;graphics h
    defb    0               ;sprites not enabled
    defb     __tms9918_CAPS_MODE0  ; Console capabilities


    defb    0               ;register 0: -     -  -    -  -  - M2 EXTVID
    defb    $F0             ;register 1: 4/16K BL GINT M1 M3 - SI MAG
    defw    PATTERN_NAME
    defb    +((PATTERN_NAME >> 10) & 0x7F)
    defw    COLOUR_TABLE
    defb    $80             ;register 3
    defw    PATTERN_GENERATOR
    defb    +((PATTERN_GENERATOR >> 11) & 0x3F) ;register 4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    $ff             ;endmarker


SECTION code_video_vdp


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode0:
    push    af
    call    __tms9918_clear_vram
    pop     af

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
    jp     __tms9918_set_font
