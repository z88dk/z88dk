

SECTION  code_video_vdp
PUBLIC   vdp_set_mode
PUBLIC   _vdp_set_mode


EXTERN  __vdp_mode0
EXTERN  __vdp_mode0_80col
EXTERN  __vdp_mode1
EXTERN  __vdp_mode2
EXTERN  __vdp_mode3
EXTERN  __vdp_mode4
EXTERN  __vdp_mode5
EXTERN  __vdp_mode6
EXTERN  __vdp_mode8
EXTERN  vdp_set_mangled_mode

INCLUDE "video/tms9918/vdp.inc"

vdp_set_mode:
_vdp_set_mode:
    ex      de,hl
    ld      hl,mode_table - 2
loop:
    inc     hl
    inc     hl
    ld      a,(hl)
    inc     hl
    cp      255
    ret     z
    cp      e
    jr      nz,loop
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    jp      (hl)


SECTION rodata_video_vdp

mode_table:
    defb    0
    defw    __vdp_mode0
IF V9938 | F18A
    defb    80
    defw    __vdp_mode0_80col
ENDIF
    defb    1
    defw    __vdp_mode1
    defb    2
    defw    __vdp_mode2
    defb    3
    defw    __vdp_mode3
IFDEF V9938
    defb    4
    defw    __vdp_mode4
    defb    5
    defw    __vdp_mode5
    defb    6
    defw    __vdp_mode6
    defb    8
    defw    __vdp_mode8
ENDIF
    defb    81
    defw    vdp_set_mangled_mode
    defb    255


;Reg/Bit    7      6    5    4    3    2    1    0
;0          -      -    -    -    -    -    M2   EXTVID
;1          4/16K  BL   GINT M1   M3   -    SI   MAG
;2          -      -    -    -    PN13 PN12 PN11 PN10   * $400
;3          CT13   CT12 CT11 CT10 CT9  CT8  CT7  CT6    * $40
;4          -      -    -    -	- -    PG13 PG12 PG11   * $800
;5          -      SA13 SA12 SA11 SA10 SA9  SA8  SA7    * $80
;6          -      -    -    -    -    SG13 SG12 SG11   * $800
;7          TC3    TC2  TC1  TC0  BD3  BD2  BD1  BD0
;
;STATUS     INT    5S   C    FS4  FS3  FS2  FS1  FS0
;
;M1,M2,M3    Select screen mode
;EXTVID      Enables external video input.
;4/16K       Selects 16kB RAM if set. No effect in MSX1 system.
;BL          Blank screen if reset; just backdrop. Sprite system inactive
;SI          16x16 sprites if set; 8x8 if reset
;MAG         Sprites enlarged if set (sprite pixels are 2x2)
;GINT        Generate interrupts if set
;PN*         Address for pattern name table
;CT*         Address for colour table (special meaning in M2)
;PG*         Address for pattern generator table (special meaning in M2)
;SA*         Address for sprite attribute table
;SG*         Address for sprite generator table
;TC*         Text colour (foreground)
;BD*         Back drop (background). Sets the colour of the border around
;            the drawable area. If it is 0, it is black (like colour 1).
;FS*         Fifth sprite (first sprite that's not displayed). Only valid
;            if 5S is set.
;C           Sprite collision detected
;5S          Fifth sprite (not displayed) detected. Value in FS* is valid.
;INT         Set at each screen update, used for interrupts.
