; VDP TEXT II mode


SECTION code_video_vdp

PUBLIC  __vdp_mode0_80col


; VDP map definitions
defc    COLOUR_TABLE      = $0800
defc    PATTERN_NAME      = $0000
defc    PATTERN_GENERATOR = $1000

defc    SPRITE_GENERATOR  = $0000       ;Unused
defc    SPRITE_ATTRIBUTE  = $0000


defc    COLUMNS = 80 

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
    defb    160-1           ;graphics w
    defb    48-1            ;graphics h
    defb    0               ;sprites not enabled
    defb     __tms9918_CAPS_MODE0  ; Console capabilities


    defb    $04             ;register 0:   0     DG IE2  IE1 M5 M4 M2 EXTVID 
    defb    $70             ;register 1:   4/16K BL GINT M1  M3 -  SI MAG
    defw    PATTERN_NAME
    defb    +(((PATTERN_NAME >> 10) & 0x7F) | 0x03) ;register 2
    defw    COLOUR_TABLE
    defb    +(((COLOUR_TABLE >> 6) & 0xff) | 0x07)  ;register 3
    defw    PATTERN_GENERATOR
    defb    +((PATTERN_GENERATOR >> 11) & 0x3F)     ;register 4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    10, +((COLOUR_TABLE >> 14) & 0x07)                  ;Colour table high
    defb    13, $0f         ;Blink off
    defb    $ff             ;endmarker


SECTION code_video_vdp


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode0_80col:
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
    ld      bc,80 * 24
    ld      a,32
    call    FILVRM

    ; Set the font
    jp     __tms9918_set_font
