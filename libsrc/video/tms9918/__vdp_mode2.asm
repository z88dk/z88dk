
SECTION code_clib

PUBLIC  __vdp_mode2

PUBLIC  __tms9918_mode2_setup_tables


INCLUDE  "video/tms9918/vdp.inc"


; VDP map definitions
defc    COLOUR_TABLE      = $2000
defc    PATTERN_NAME      = $1800
defc    PATTERN_GENERATOR = $0000

defc    SPRITE_GENERATOR  = $3800
defc    SPRITE_ATTRIBUTE  = $1b00


EXTERN  __tms9918_mode2_scroll
EXTERN  __tms9918_mode2_cls
EXTERN  __tms9918_mode2_vpeek
EXTERN  __tms9918_set_font
EXTERN  __tms9918_clear_vram
EXTERN  __tms9918_attribute
EXTERN  __tms9918_border
EXTERN  __tms9918_switch_mode
EXTERN  __tms9918_CAPS_MODE2
EXTERN  __tms9918_set_tables
EXTERN  __tms9918_setup_spec

EXTERN  __tms9918_colour_table
EXTERN  __tms9918_pattern_generator
EXTERN  __tms9918_pattern_name

EXTERN  VDPreg_Write
EXTERN  FILVRM
EXTERN  SETWRT


SECTION rodata_clib


; Specification of VDP mode 0
spec_mode2:
    defb     32      ;columsn
    defb     24      ;rows
    defb     256-1   ;Graphics w
    defb     192-1   ;Graphic h
    defb     1       ;Sprites enabled
    defb     __tms9918_CAPS_MODE2  ; Console capabilities

    

; Table adderesses
mode2_addresses:
    defb    2         ;register 0:   -     -  -    -  -  - M2 EXTVID
    defb    $E0       ;register 1:   4/16K BL GINT M1 M3 - SI MAG
    defw    PATTERN_NAME
    defw    COLOUR_TABLE
    defb    $ff             ;register 3
    defw    PATTERN_GENERATOR
    defb    $03             ;register 4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    $ff             ;endmarker


SECTION code_clib


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode2:
    push    af
    call    __tms9918_clear_vram
    pop     af

    ld      hl, mode2_addresses
    call    __tms9918_set_tables

    ; Set the screen colour
    ld      a,(__tms9918_border)
    and     15
    ld      e,7
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.

   ; Setup the pattern names
    call    __tms9918_mode2_setup_tables

    ; Set the VRAM attribute area
    ld      bc,6144
    ld      a,(__tms9918_attribute)
    ld      hl,(__tms9918_colour_table)
    push    bc
    call    FILVRM
    pop     bc
    ; And clear the pattern generator
    xor     a                       ; clear graphics page
    ld      hl,(__tms9918_pattern_generator)
    call    FILVRM

    ; Return our info block
    ld      hl,spec_mode2
    call    __tms9918_setup_spec
    ret


__tms9918_mode2_setup_tables:
    ld      hl,(__tms9918_pattern_name)      ;pattern name
    call    SETWRT
IF VDP_DATA >= 0
    ld      bc,VDP_DATA
ENDIF
    xor     a
    ld      e,3
pattern:
IF VDP_DATA < 0
    ld      (-VDP_DATA),a
ELSE
    out     (c),a
ENDIF
    inc     a
    jr      nz,pattern
    dec     e
    jr      nz,pattern
    ret