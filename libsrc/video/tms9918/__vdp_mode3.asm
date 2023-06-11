; We follow the MSX naming convention, so confusingly this is VDP mode 0 - 32x24

SECTION code_video_vdp

PUBLIC  __vdp_mode3
PUBLIC  __tms9918_mode3_cls

INCLUDE  "video/tms9918/vdp.inc"


; VDP map definitions
defc    COLOUR_TABLE      = $0000
defc    PATTERN_NAME      = $800
defc    PATTERN_GENERATOR = $0000

defc    SPRITE_GENERATOR  = $3800
defc    SPRITE_ATTRIBUTE  = $1b00



EXTERN  __tms9918_clear_vram
EXTERN  __tms9918_border
EXTERN  __tms9918_CAPS_MODE3
EXTERN  __tms9918_set_tables

EXTERN  __tms9918_pattern_generator
EXTERN  __tms9918_pattern_name

EXTERN l_tms9918_disable_interrupts
EXTERN l_tms9918_enable_interrupts

EXTERN  VDPreg_Write
EXTERN  FILVRM
EXTERN  SETWRT
EXTERN  l_ret


SECTION rodata_video_vdp


; Specification of VDP mode 0
spec_mode3:




; Table adderesses
mode3_addresses:
    defb     32      ;columns
    defb     24      ;rows
    defb     64-1    ;Graphics w
    defb     48-1    ;Graphic h
    defb     1       ;Sprite mode
    defb     __tms9918_CAPS_MODE3  ; Console capabilities


    defb    0         ;register 0:   -     -  -    -  -  - M2 EXTVID
    defb    @11101000 ;register 1:   4/16K BL GINT M1 M3 - SI MAG
    defw    PATTERN_NAME
    defb    +((PATTERN_NAME >> 10) & 0x7F)
    defw    COLOUR_TABLE
    defb    $00             ;register 3
    defw    PATTERN_GENERATOR
    defb    +((PATTERN_GENERATOR >> 11) & 0x3F)     ;register 4
    defw    SPRITE_ATTRIBUTE
    defw    SPRITE_GENERATOR
    defb    $ff             ;endmarker


SECTION code_video_vdp


; Initialises the display + returns terminal structure
; Entry: a = screenmode
__vdp_mode3:
    push    af
    call    __tms9918_clear_vram
    pop     af

    ld      hl, mode3_addresses
    call    __tms9918_set_tables

    ; Set the screen colour
    ld      a,(__tms9918_border)
    and     15
    ld      e,7
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.

    call    __tms9918_mode3_cls

    ; Set up the name table
    call    l_tms9918_disable_interrupts
    ld      hl,(__tms9918_pattern_name)
    call    SETWRT
IF VDP_DATA >= 256
    ld      bc,VDP_DATA
    exx
ENDIF
    ld      de,6
inimlt0:
    ld      c,4
inimlt1:
    ld      a,d
    ld      b,$20
inimlt2:
IF VDP_DATA < 256
    VDPOUT(VDP_DATA)
ELSE
    exx
    out     (c),a
    exx
ENDIF
    inc     a
    djnz    inimlt2
    dec     c
    jr      nz,inimlt1
    ld      d,a
    dec     e
    jr      nz,inimlt0
    call    l_tms9918_enable_interrupts
    ret
    

__tms9918_mode3_cls:
    ;Clear the pattern generator table
    ld      hl,(__tms9918_pattern_generator) 
    ld      bc,1536
    xor     a
    jp      FILVRM
