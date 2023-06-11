; V9938, mode8 = screen 8 = graphic 7
;
; 256x192 8bpp

SECTION code_video_vdp

INCLUDE  "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __vdp_mode8
PUBLIC  __v9938_mode8_cls




; VDP map definitions
defc    COLOUR_TABLE      = $0000       ;unused
defc    PATTERN_NAME      = $0000       
defc    PATTERN_GENERATOR = $0000       ;unused

defc    SPRITE_GENERATOR  = $f000
defc    SPRITE_ATTRIBUTE  = $fa00



EXTERN  __tms9918_set_font
EXTERN  __tms9918_clear_vram
EXTERN  __tms9918_8bpp_attr
EXTERN  __tms9918_border
EXTERN  __tms9918_CAPS_MODE8
EXTERN  __tms9918_set_tables  

EXTERN  __tms9918_pattern_name


EXTERN  VDPreg_Write
EXTERN  FILVRM
EXTERN  SETWRT


SECTION rodata_video_vdp




; Table adderesses
mode8_addresses:
    defb     32      ;columns
    defb     24      ;rows
    defb     256-1   ;Graphics w
    defb     192-1   ;Graphic h
    defb     2       ;Sprite mode
    defb     __tms9918_CAPS_MODE8  ; Console capabilities

    defb    14         ;register 0:   0     DG IE2  IE1 M5 M4 M2 EXTVID
    defb    $60       ;register 1:   4/16K BL GINT M1  M3 -  SI MAG
    defw    PATTERN_NAME
    defb    +(((PATTERN_NAME >> 10) & 0x7F) | 0x1F) ;r2
    defw    COLOUR_TABLE
    defb    $80                                       ;r3
    defw    PATTERN_GENERATOR
    defb    $01                                       ;r4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    10, +((COLOUR_TABLE >> 14) & 0x07)
    defb    5, +((SPRITE_ATTRIBUTE >> 7) & 0xFF) | 0x07
    defb    11, +(SPRITE_ATTRIBUTE >> 15) & 0x03
    defb    $ff             ;endmarker


SECTION code_video_vdp


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode8:
    push    af
    call    __tms9918_clear_vram
    pop     af

    ld      hl, mode8_addresses
    call    __tms9918_set_tables

    ; Set the screen colour
    ld      a,(__tms9918_border)
    and     15
    ld      e,7
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.


__v9938_mode8_cls:
    ; Clear VRAM screen
    ld      bc,+((256 * 192))

    ; Get the background colour
    ld      a,(__tms9918_8bpp_attr+1)
    ld      hl,(__tms9918_pattern_name)
    jp      FILVRM


ENDIF
