;
;    z88dk library: Generic VDP support code
;
;    extern void __FASTCALL__ msx_set_mode(unsigned char id);
;
;    set screen mode
;
;    $Id: gen_set_mode.asm $
;

    SECTION  code_clib
    PUBLIC   msx_set_mode
    PUBLIC   _msx_set_mode
    
    INCLUDE  "video/tms9918/vdp.inc"

    EXTERN   SETWRT
    EXTERN   FILVRM
    EXTERN   RG0SAV
    EXTERN   CONSOLE_COLUMNS
    EXTERN   l_tms9918_disable_interrupts
    EXTERN   l_tms9918_enable_interrupts
    EXTERN   __tms9918_screen_mode
    EXTERN   __tms9918_attribute
    EXTERN   __tms9918_border
    EXTERN   __tms9918_set_font
    EXTERN   __tms9918_pattern_name
    EXTERN   __tms9918_pattern_generator
    EXTERN   __console_w

    EXTERN   generic_console_caps
    EXTERN   __tms9918_CAPS_MODE0
    EXTERN   __tms9918_CAPS_MODE1
    EXTERN   __tms9918_CAPS_MODE2

msx_set_mode:
_msx_set_mode:
    ld    a,l
    ld    hl,__tms9918_screen_mode
    and   a
    jr    z,init_mode1
    cp    1
    jr    z,init_mode0
    cp    2
    jp    z,init_mode2
    ret


; VDP Mode 0: 32x24
init_mode0:
    ld   (hl),a
; MSX:  $00,$F0,$00,$00,$01,$00,$00,$F4
; SVI:  $00,$F0,$00,$FF,$01,$36,$07,$F4
; SC3:  $00,$F0,$0F,$FF,$03,$76,$03,$13
; MTX:  $00,$D0,$07,$00,$03,$7E,$07


    call clear_sprites
    ; reg0  - TEXT MODE
    ld    e,$00
IF FORm5___2
    ld    a,1        ; external video flag bit must be set on M5
ELSE
    xor   a          ; .. and reset on the other targets
ENDIF    
    call  VDPreg_Write

    ld    e,$01
    ld    a,$E0
    call  VDPreg_Write    ; reg1  - text MODE
    
    ld    a,$06           ; $1800 (character map, 768 bytes)
    call  VDPreg_Write    ; reg2  -  NAME TABLE
    
    ld    a,$80           ; $2000  - Colour table is 32 bytes long
    call  VDPreg_Write    ; reg3  -  COLOUR TABLE
    
    ld    a,$00           ; $0000  - Where the font will go
    call  VDPreg_Write    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    
    ld    a,$36           ; $1b00
    call  VDPreg_Write    ; reg5  -  SPRITE ATTR. TAB.
    
    ld    a,$07           ; $3800
    call  VDPreg_Write    ; reg6  -  SPRITE PATTERN GEN. TAB.
    
    ld    a,(__tms9918_border)
    and   15
    call  VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
   

    ld    a,__tms9918_CAPS_MODE0
    ld    (generic_console_caps),a
    ld    a,CONSOLE_COLUMNS	;Needs to be overridden by ANSI
    ld    (__console_w),a 
    ld    hl,$1800
    ld    (__tms9918_pattern_name),hl
    ld    hl,$0000
    ld    (__tms9918_pattern_generator),hl

    ld    hl,$1800	;Clear the name table
    ld    bc,768
    ld    a,32
    call  FILVRM
    ; Set the colour for all characters
    ld    a,(__tms9918_attribute)
    ld    hl,$2000
    ld    bc,32
    call  FILVRM
    call  __tms9918_set_font
    ret

clear_sprites:
    ld    hl,$3800
    ld    bc,2048
    xor   a
    call  FILVRM
    ret

; Switch 2 VDP Mode 1
; 40x24
init_mode1:
    ld   (hl),a
    call  clear_sprites

    ; reg0  - TEXT MODE
    ld    e,$00
IF FORm5___2
    ld    a,1        ; external video flag bit must be set on M5
ELSE
    xor   a          ; .. and reset on the other targets
ENDIF
    call  VDPreg_Write

    ld    e,$01
    ld    a,$F0
    call  VDPreg_Write    ; reg1  - text MODE 
    
    xor   a               ; $0000 (960 bytes long)
    call  VDPreg_Write    ; reg2  -  NAME TABLE
    
    ld    a,$80           ; Unused (no colour)
    call  VDPreg_Write    ; reg3  -  COLOUR TABLE
    
    ld    a,$01           ; $800  - Where the font will go
    call  VDPreg_Write    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    
    ld    a,$36           ; Unused (sprites inactive)
    call  VDPreg_Write    ; reg5  -  SPRITE ATTR. TAB.
    
    ld    a,$07           ; Unused (sprites inactive)
    call  VDPreg_Write    ; reg6  -  SPRITE PATTERN GEN. TAB.

    ld    a,(__tms9918_attribute)    
    call  VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    

    ld    a,__tms9918_CAPS_MODE1
    ld    (generic_console_caps),a
    ld    a,40
    ld    (__console_w),a 
    ld    hl,$800
    ld    (__tms9918_pattern_generator),hl
    ld    hl,$0000
    ld    (__tms9918_pattern_name),hl
    ld    bc,1024
    ld    a,32
    call  FILVRM
    call  __tms9918_set_font
    ret
    
;
; -- Thanks to Saverio Russo his initial hints --
;
; Switch 2 Video Mode n. 2

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
init_mode2:
    ld   (hl),a
    call clear_sprites
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; SVI:  $02,$E0,$06,$FF,$03,$36,$07,$07
; MSX:  $02,$E0,$06,$FF,$03,$36,$07,$04
; SC3:  $02,$E0,$0E,$FF,$03,$76,$03,$05
; SC3B: $02,$E2,$0E,$FF,$03,$76,$03,$00
; EINS: $02,$C0,$0E,$FF,$03,$76,$03,$F4   $0F for backdrop color = WHITE 
; MTX:  $02,$C0,$0F,$FF,$03,$7E,$07
; MTXb:    $02,$C2,$0F,$FF,$03,$73,$07,$F3
; MTXc:    $02,$E2,$06,$FF,$03,$38,$07,$01    ; astropac
; MTXd: $02,$C2,$06,$FF,$03,$38,$07,$01    ; kilopede
; M5:   $02,$E2,$06,$FF,$03,$36,$07,$61
; M5:   $03,$A2,$0E,$FF,$03,$76,$03,$11 ; name table at 3800 in place of 1800
; PV2:  $02,$82,$07,$ff,$03,$3e,$03,$f0 ; and then r1 = e2

; Compare example from MSX emulator for M5,
; on reg#0 of the SORD M5, external video flag bit must be set
; msx:  02 62 11 23 21 33 11 E0
; M5:   03 E2 11 23 21 33 11 E1

; Final state: 02 e0 06 ff 03 76 03 00
;
;0000 - 17ff = PG Pattern Generator
;1800 - 1b00 = PN Pattern Name
;2000 - 3800 = CT Colour
;3800        = Sprite 
;1b00        = Sprite attribute

    ; reg1  - GRAPH MODE, first reset bit #6 to blank the screen
    ld    e,$01
    xor   a        ; bit 7 must be reset on sc3000
    call  VDPreg_Write
    
    ; reg2  -  NAME TABLE
    ld    a,$06        ; $1800
    call  VDPreg_Write

    ; reg3  -  COLOUR TABLE
    ld    a,$FF		; bit 7 set -> $2000
    call  VDPreg_Write

    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    ld    a,$03		; bit 2 reset -> $0000
    call  VDPreg_Write
    
    ; reg5  -  SPRITE ATTR. TAB.
    ld    a,$36		;$1b00
    call  VDPreg_Write
    
    ; reg6  -  SPRITE PATTERN GEN. TAB.
    ld    a,$07        ; $3800
    call  VDPreg_Write
    
    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    ld    a,(__tms9918_border)
    and   15
    call  VDPreg_Write

    ; reg0  - GRAPH MODE
    ld    e,$00
IF FORm5
    ld    a,$03        ; set bit 0 on m5___2 (to be confirmed)
ELSE
    ld    a,$02        ; .. and reset on the other targets
ENDIF
    call    VDPreg_Write

    ; reg1 - GRAPH MODE
    ; (it was first set to $80)
    ;ld    a,$E2   ; MTX, M5
IF FORadam
    ld    a,$D0        ;Disable interrupt on Adam
ELSE
    ld    a,$E0   ; MTX, M5
ENDIF
    call  VDPreg_Write
    
    
    ; Pattern table should probably be initialized on other targets as well,
    ; Memotech MTX does not seem to require the initialization (discovered experimentally)
    ; SETWRT on the M5 sets C correctly on exit, it may be differente elsewhere

    ld    hl,$1800
    call  SETWRT
IF VDP_DATA >= 0
    ld    bc,VDP_DATA
ENDIF
    xor   a
    ld    e,3
pattern:
IF VDP_DATA < 0
    ld    (-VDP_DATA),a
ELSE
    out   (c),a
ENDIF
    inc   a
    jr    nz,pattern
    dec   e
    jr    nz,pattern

    ld    a,__tms9918_CAPS_MODE2
    ld    (generic_console_caps),a
    ld    a,CONSOLE_COLUMNS
    ld    (__console_w),a 
	
    ld    bc,6144    ; set VRAM attribute area
    ld    a,(__tms9918_attribute)   ; white on black
    ld    hl,8192
    push  bc
    call  FILVRM
    pop   bc
    xor   a			; clear graphics page
    ld    h,a
    ld    l,a
    jp    FILVRM

    
; Switch 2 Video Mode n. 3
inimlt:
; On MTX, a game sets the 16 colours mode as follows:
; -- graph mode (reg0=2)
; reg1 - c2
; reg2 - 06        -- bit 0 and 3 are toggled ??
; reg3 - ff
; reg4 - 03
; reg5 - 38
; reg6 - 07
; reg7 - 01
    ret


; *** WRTVDP ***
; Copy a value into VDP reg
; IN: E = reg, A = val
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
VDPreg_Write:  
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

    ld    d,a
    call  l_tms9918_disable_interrupts
    ld    a,d
IF VDP_CMD < 0
    ld    (-VDP_CMD),a
ELSE
    ld    bc,VDP_CMD
    out   (c),a
ENDIF
    ld    a,e
    and   $07
    or    $80        ; enable bit for "set register" command
IF VDP_CMD < 0
    ld    (-VDP_CMD),a
ELSE
    out   (c),a
ENDIF
    push  hl
    ld    a,d
    ld    hl,RG0SAV
    ld    d,0
    add   hl,de
    ld    (hl),a
    pop   hl
    inc   e
    call  l_tms9918_enable_interrupts
    ret

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
