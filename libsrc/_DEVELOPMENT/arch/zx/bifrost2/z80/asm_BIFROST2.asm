

IF !_CLIB_TARGET_CFG_ASM_
defc _CLIB_TARGET_CFG_ASM_ = 1

; ********************************************************************
; IF YOU MAKE CHANGES TO THIS FILE YOU MUST RECOMPILE THE ZX LIBRARIES
; ********************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ZX SPECTRUM - TARGET CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------------------------
;-- ARCHITECTURE CONSTANTS ------------------------------------
;--------------------------------------------------------------

defc __spectrum     = 1

; 1 = spectrum 48k
; 2 = spectrum 128k
; 3 = pentagon

defc __clock_freq   = 3500000          ; Hz

defc __z80_cpu_info = $01

; bit 0 = $01 = if set indicates an nmos z80 (if unsure set it)
; bit 1 = $02 = allow undocumented instruction "sll r"


;--------------------------------------------------------------
;-- GAMES/BIFROST*2 -------------------------------------------
;--------------------------------------------------------------

; Animation size: 2 or 4 frames per animation group
defc __BIFROST2_ANIM_GROUP = 4

; First non-animated frame
defc __BIFROST2_STATIC_MIN = 128

; Value subtracted from non-animated frames
defc __BIFROST2_STATIC_OVERLAP = 128

; Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)
defc __BIFROST2_TILE_IMAGES = 49000

; Tile rendering order (1 for sequential, 7 or 9 for distributed)
defc __BIFROST2_TILE_ORDER = 7

; Location of the tile map (11x10=110 tiles)
defc __BIFROST2_TILE_MAP = 65281

; Number of char rows rendered in multicolor (3-22)
; (notice that addresses from 57690+332*TOTAL_ROWS to 64994 are unused)
;;


;--------------------------------------------------------------
;-- GAMES/NIRVANA- --------------------------------------------
;--------------------------------------------------------------

defc __NIRVANAM_OPTIONS = 0

; bit 0 = $01 = enable wide draw
; bit 1 = $02 = enable wide sprites

;;

; total number of rows drawn by nirvana- 1-22
; do not uncomment - this is an m4 define

defc __NIRVANAM_TILE_IMAGES = 48000  ; default location of bicolour tiles (16x16 pix, 48 bytes each)
defc __NIRVANAM_WIDE_IMAGES = 54000  ; default location of wide tiles (24x16 pix, 72 bytes each)
defc __NIRVANAM_CHAR_TABLE  = 15360  ; default location of character set (8x8 pix, 8 bytes each)


;--------------------------------------------------------------
;-- GAMES/NIRVANA+ --------------------------------------------
;--------------------------------------------------------------

defc __NIRVANAP_OPTIONS = 0

; bit 0 = $01 = enable wide draw
; bit 1 = $02 = enable wide sprites

;;

; total number of rows drawn by nirvana+ 1-23
; do not uncomment - this is an m4 define

defc __NIRVANAP_TILE_IMAGES = 48000  ; default location of bicolour tiles (16x16 pix, 48 bytes each)
defc __NIRVANAP_WIDE_IMAGES = 54000  ; default location of wide tiles (24x16 pix, 72 bytes each)
defc __NIRVANAP_CHAR_TABLE  = 15360  ; default location of character set (8x8 pix, 8 bytes each)


;--------------------------------------------------------------
;-- GAMES/SP1 -------------------------------------------------
;--------------------------------------------------------------

; display characteristics

defc SP1V_DISPORIGX     = 0            ; x coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPORIGY     = 0            ; y coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPWIDTH     = 32           ; width of area managed by sp1 in characters (16, 24, 32 ok as of now)
defc SP1V_DISPHEIGHT    = 24           ; height of area managed by sp1 in characters

; buffers

defc SP1V_PIXELBUFFER   = $d1f7        ; address of an 8-byte buffer to hold intermediate pixel-draw results
defc SP1V_ATTRBUFFER    = $d1ff        ; address of a single byte buffer to hold intermediate colour-draw results

; data structure locations

defc SP1V_TILEARRAY     = $f000        ; address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
defc SP1V_UPDATEARRAY   = $d200        ; address of the 10*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
defc SP1V_ROTTBL        = $f000        ; location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                       ;  pointer ($f200-$ffff in this default case).  Set to $0000 if the table is not needed (if, for example, all sprites
                                       ;  are drawn at exact horizontal character coordinates or you use pre-shifted sprites only).
; sp1 variables

defc SP1V_UPDATELISTH   = $d1ed        ; address of 10-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $d1ef        ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

; note: SP1V_UPDATELISTT is located inside the dummy struct_sp1_update pointed at by SP1V_UPDATELISTH

; default memory map

; With these default settings the memory map is:
;
; ADDRESS (HEX)   LIBRARY  DESCRIPTION
;
; f200 - ffff     SP1.LIB  horizontal rotation tables
; f000 - f1ff     SP1.LIB  tile array
; d200 - efff     SP1.LIB  update array for full size screen 32x24
; d1ff - d1ff     SP1.LIB  attribute buffer
; d1f7 - d1fe     SP1.LIB  pixel buffer
; d1ed - d1f6     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * d1ef - d1f0  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
; d1d4 - d1ec     --free-  25 bytes free
; d1d1 - d1d3     -------  JP to im2 service routine (im2 table filled with 0xd1 bytes)
; d101 - d1d0     --free-  208 bytes
; d000 - d100     IM2.LIB  im 2 vector table (257 bytes)
; ce00 - cfff     -------  z80 stack (512 bytes) set SP=d000


;--------------------------------------------------------------
;-- SOUND/BIT -------------------------------------------------
;--------------------------------------------------------------

; 1-bit sound constants

defc __sound_bit_method       = 1      ; 1 = port_8, 2 = port_16, 3 = memory
defc __sound_bit_port         = $fe    ; port or memory address
defc __sound_bit_toggle       = $10    ; bits to toggle to make noise
defc __sound_bit_toggle_pos   = 4      ; bit position to test state of output
defc __sound_bit_read_mask    = $17    ; part of state byte to be used in output
defc __sound_bit_write_mask   = $e8    ; part of state byte to be preserved on write

ENDIF


; -----------------------------------------------------------------------------
; BIFROST*2 ENGINE by Einar Saukas
; A Rainbow Graphics 20 Columns 8x1 Multicolor Engine for Animated Tiles
; Adapted to z88dk by aralbrec
; -----------------------------------------------------------------------------

org 51625

; -----------------------------------------------------------------------------
; Start engine
;
; Destroys:
;   AF
;
; Address:
;   51625
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_start

asm_BIFROST2_start:
activate_engine:
        di
        ld      a, $fe
        ld      i, a
        im      2
        ei
        ret

; -----------------------------------------------------------------------------
; Stop engine
;
; Destroys:
;   AF
;
; Address:
;   51634
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_stop

asm_BIFROST2_stop:
deactivate_engine:
        di
        ld      a, $3f
        ld      i, a
        im      1
        ei
        ret

; -----------------------------------------------------------------------------
; Internal routine
; -----------------------------------------------------------------------------
skip_tile:
        ld      b, 92
delay_tile:
        inc     hl
        djnz    delay_tile
        inc     hl
        ret

; -----------------------------------------------------------------------------
; Instantly show/animate next 2 tile map positions in drawing order
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51650
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showNext2Tiles

asm_BIFROST2_showNext2Tiles:
show_next2:
        call    show_next_tile

; -----------------------------------------------------------------------------
; Instantly show/animate next tile map position in drawing order
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51653
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showNextTile

asm_BIFROST2_showNextTile:
show_next_tile:
        ld      de, $1001               ; D = lin (16,32,48..176), E = col (1,3,5..19)
        ld      a, e
        sub     +(10-__BIFROST2_TILE_ORDER)*2
        ld      e, a
        jr      nc, prev_lin
        add     a, 20
        ld      e, a
        xor     a
        jr      reset_lin
prev_lin:
        ld      a, d
        sub     16
        ld      d, a
        cp      16
reset_lin:
        sbc     a, a
        and     +((22+1)/2)*16
        add     a, d
        ld      d, a
        ld      (show_next_tile+1), de

; -----------------------------------------------------------------------------
; Instantly show/animate specified tile map position on screen
;
; Parameters:
;   D: lin (16,32,48..176)
;   E: col (1,3,5..19)
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51683
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_showTilePosH
PUBLIC _BIFROST2_TILE_MAP

asm_BIFROST2_showTilePosH:
show_tile_pos:
        ld      a, d                    ; A = 8*(lin/8)
        rrca                            ; A = 4*(lin/8)
        rrca                            ; A = 2*(lin/8)
        add     a, d                    ; A = 10*(lin/8)
        add     a, e                    ; A = 10*(lin/8)+col
        sub     19                      ; A = 10*(lin/8)-20+(col+1)
        rra                             ; A = 10*(lin/16)-10+(col+1)/2
        ld      l, a
defc _BIFROST2_TILE_MAP = __BIFROST2_TILE_MAP
        ld      h, __BIFROST2_TILE_MAP/256   ; HL = TILEMAP+10*(lin/16)-10+(col-1)/2

get_tile:
        ld      a,(hl)
        cp      __BIFROST2_STATIC_MIN
        jp      c, animate_tile
        inc     a
        jr      z, skip_tile
        sub     1+__BIFROST2_STATIC_OVERLAP
        jr      draw_tile
animate_tile:
        rrca
IF (__BIFROST2_ANIM_GROUP = 4)
        rrca
        add     a, $40
        rlca
ELSE
        nop
        add     a, $80
        nop
ENDIF
        rlca
        ld      (hl), a

; -----------------------------------------------------------------------------
; Instantly draw tile at specified position on screen
;
; Parameters:
;   A: tile number (0-255)
;   D: lin (0-207)
;   E: col (0-20)
;
; Destroys:
;   AF, BC, DE, HL
;
; Address:
;   51714
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_drawTileH
PUBLIC _BIFROST2_TILE_IMAGES

asm_BIFROST2_drawTileH:
draw_tile:
; calculate screen bitmap lookup address
        ld      (exit_draw+1), sp
        ld      h, lookup/512
        ld      l, d                    ; HL = lookup/2+lin
        add     hl, hl                  ; HL = lookup+2*lin
        ld      sp, hl                  ; SP = lookup+2*lin

; preserve values
        ld      b, e                    ; B = col
        ld      c, h

; calculate tile image address
        ld      l, 0                    ; AL = 256*tile
        rra
        rr      l                       ; AL = 128*tile
        rra
        rr      l                       ; AL = 64*tile
        ld      h, a                    ; HL = 64*tile
defc _BIFROST2_TILE_IMAGES = ASMPC + 1
        ld      de, __BIFROST2_TILE_IMAGES
        add     hl, de                  ; HL = TILE_IMAGES+64*tile

; draw bitmap lines

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

        pop     de
        ld      a, e
        add     a, b
        ld      e, a
        ldi
        ldi

; calculate multicolor attribute address
        ex      de, hl                  ; DE = TILE_IMAGES+64*tile+32
        rr      b                       ; B = INT(col/2)
        ld      c, 235                  ; BC = 256*INT(col/2)+235
        ld      h, b
        ld      l, c                    ; HL = 256*INT(col/2)+235
        srl     h
        rr      l                       ; HL = 128*INT(col/2)+117
        add     hl, bc                  ; HL = 384*INT(col/2)+352 = 384*INT(col/2)+384-32
        add     hl, sp                  ; HL = SP+384*INT(col/2)+384-32 = (lookup+384)+lin*2+384*INT(col/2)
        ld      sp, hl
        ex      de, hl

; distinguish between even/odd column
        rra
        jr      nc, draw_even_col

; draw multicolor attributes starting at odd column

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ldi

        pop     de
        ldi
        ld      a, (hl)
        ld      (de), a
exit_draw:
        ld      sp, 0
        ret

draw_even_col:
        ld      a, b                    ; A = INT(col/2)
        cp      10
        ld      de, -384
        jr      z, draw_last_col

; draw right side of tile

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        inc     hl
        pop     de
        ldi

        and     a
        jr      z, exit_draw

        ld      de, -32
        add     hl, de
        ld      de, -(384+32)
draw_last_col:
        ex      de, hl
        add     hl, sp
        ld      sp, hl
        ex      de, hl

; draw left side of tile

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi
        inc     hl

        pop     de
        inc     de
        ldi

        jp      exit_draw

; -----------------------------------------------------------------------------
; Lookup tables
; -----------------------------------------------------------------------------
extra_buffer:

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

        defw      0                               ; columns 9 and 10 (6)
        defw      0                               ; columns 7 and 8 (4)

lookup:

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with screen coordinates


IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (0*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (1*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (2*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (3*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (4*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (5*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (6*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (0 < 22)
        defw      16384 + (((0+1)/8)*2048) + (7*256) + (((0+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (0*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (1*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (2*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (3*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (4*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (5*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (6*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (1 < 22)
        defw      16384 + (((1+1)/8)*2048) + (7*256) + (((1+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (0*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (1*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (2*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (3*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (4*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (5*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (6*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (2 < 22)
        defw      16384 + (((2+1)/8)*2048) + (7*256) + (((2+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (0*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (1*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (2*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (3*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (4*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (5*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (6*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (3 < 22)
        defw      16384 + (((3+1)/8)*2048) + (7*256) + (((3+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (0*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (1*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (2*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (3*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (4*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (5*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (6*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (4 < 22)
        defw      16384 + (((4+1)/8)*2048) + (7*256) + (((4+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (0*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (1*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (2*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (3*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (4*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (5*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (6*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (5 < 22)
        defw      16384 + (((5+1)/8)*2048) + (7*256) + (((5+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (0*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (1*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (2*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (3*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (4*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (5*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (6*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (6 < 22)
        defw      16384 + (((6+1)/8)*2048) + (7*256) + (((6+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (0*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (1*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (2*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (3*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (4*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (5*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (6*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (7 < 22)
        defw      16384 + (((7+1)/8)*2048) + (7*256) + (((7+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (0*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (1*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (2*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (3*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (4*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (5*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (6*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (8 < 22)
        defw      16384 + (((8+1)/8)*2048) + (7*256) + (((8+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (0*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (1*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (2*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (3*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (4*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (5*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (6*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (9 < 22)
        defw      16384 + (((9+1)/8)*2048) + (7*256) + (((9+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (0*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (1*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (2*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (3*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (4*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (5*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (6*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (10 < 22)
        defw      16384 + (((10+1)/8)*2048) + (7*256) + (((10+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (0*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (1*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (2*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (3*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (4*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (5*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (6*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (11 < 22)
        defw      16384 + (((11+1)/8)*2048) + (7*256) + (((11+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (0*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (1*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (2*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (3*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (4*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (5*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (6*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (12 < 22)
        defw      16384 + (((12+1)/8)*2048) + (7*256) + (((12+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (0*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (1*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (2*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (3*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (4*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (5*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (6*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (13 < 22)
        defw      16384 + (((13+1)/8)*2048) + (7*256) + (((13+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (0*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (1*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (2*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (3*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (4*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (5*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (6*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (14 < 22)
        defw      16384 + (((14+1)/8)*2048) + (7*256) + (((14+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (0*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (1*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (2*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (3*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (4*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (5*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (6*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (15 < 22)
        defw      16384 + (((15+1)/8)*2048) + (7*256) + (((15+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (0*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (1*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (2*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (3*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (4*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (5*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (6*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (16 < 22)
        defw      16384 + (((16+1)/8)*2048) + (7*256) + (((16+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (0*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (1*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (2*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (3*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (4*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (5*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (6*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (17 < 22)
        defw      16384 + (((17+1)/8)*2048) + (7*256) + (((17+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (0*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (1*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (2*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (3*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (4*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (5*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (6*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (18 < 22)
        defw      16384 + (((18+1)/8)*2048) + (7*256) + (((18+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (0*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (1*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (2*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (3*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (4*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (5*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (6*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (19 < 22)
        defw      16384 + (((19+1)/8)*2048) + (7*256) + (((19+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (0*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (1*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (2*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (3*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (4*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (5*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (6*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (20 < 22)
        defw      16384 + (((20+1)/8)*2048) + (7*256) + (((20+1)%8)*32)
ELSE
        defw      0
ENDIF



IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (0*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (1*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (2*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (3*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (4*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (5*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (6*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF

IF (21 < 22)
        defw      16384 + (((21+1)/8)*2048) + (7*256) + (((21+1)%8)*32)
ELSE
        defw      0
ENDIF



        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 1 & 2

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/19)*(3-0)*7)+40
        defw      race_raster+(0*333)+30
        defw      race_raster+(0*333)+73
        defw      race_raster+(0*333)+122
IF SPECMODEL=3
        defw      race_raster+(0*333)+164
ELSE
        defw      race_raster+(0*333)+86
ENDIF
        defw      race_raster+(0*333)+222
        defw      race_raster+(0*333)+260
        defw      race_raster+(0*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/19)*(3-1)*7)+40
        defw      race_raster+(1*333)+30
        defw      race_raster+(1*333)+73
        defw      race_raster+(1*333)+122
IF SPECMODEL=3
        defw      race_raster+(1*333)+164
ELSE
        defw      race_raster+(1*333)+86
ENDIF
        defw      race_raster+(1*333)+222
        defw      race_raster+(1*333)+260
        defw      race_raster+(1*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/19)*(3-2)*7)+40
        defw      race_raster+(2*333)+30
        defw      race_raster+(2*333)+73
        defw      race_raster+(2*333)+122
IF SPECMODEL=3
        defw      race_raster+(2*333)+164
ELSE
        defw      race_raster+(2*333)+86
ENDIF
        defw      race_raster+(2*333)+222
        defw      race_raster+(2*333)+260
        defw      race_raster+(2*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/19)*(3-3)*7)+40
        defw      race_raster+(3*333)+30
        defw      race_raster+(3*333)+73
        defw      race_raster+(3*333)+122
IF SPECMODEL=3
        defw      race_raster+(3*333)+164
ELSE
        defw      race_raster+(3*333)+86
ENDIF
        defw      race_raster+(3*333)+222
        defw      race_raster+(3*333)+260
        defw      race_raster+(3*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/19)*(3-4)*7)+40
        defw      race_raster+(4*333)+30
        defw      race_raster+(4*333)+73
        defw      race_raster+(4*333)+122
IF SPECMODEL=3
        defw      race_raster+(4*333)+164
ELSE
        defw      race_raster+(4*333)+86
ENDIF
        defw      race_raster+(4*333)+222
        defw      race_raster+(4*333)+260
        defw      race_raster+(4*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/19)*(3-5)*7)+40
        defw      race_raster+(5*333)+30
        defw      race_raster+(5*333)+73
        defw      race_raster+(5*333)+122
IF SPECMODEL=3
        defw      race_raster+(5*333)+164
ELSE
        defw      race_raster+(5*333)+86
ENDIF
        defw      race_raster+(5*333)+222
        defw      race_raster+(5*333)+260
        defw      race_raster+(5*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/19)*(3-6)*7)+40
        defw      race_raster+(6*333)+30
        defw      race_raster+(6*333)+73
        defw      race_raster+(6*333)+122
IF SPECMODEL=3
        defw      race_raster+(6*333)+164
ELSE
        defw      race_raster+(6*333)+86
ENDIF
        defw      race_raster+(6*333)+222
        defw      race_raster+(6*333)+260
        defw      race_raster+(6*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/19)*(3-7)*7)+40
        defw      race_raster+(7*333)+30
        defw      race_raster+(7*333)+73
        defw      race_raster+(7*333)+122
IF SPECMODEL=3
        defw      race_raster+(7*333)+164
ELSE
        defw      race_raster+(7*333)+86
ENDIF
        defw      race_raster+(7*333)+222
        defw      race_raster+(7*333)+260
        defw      race_raster+(7*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/19)*(3-8)*7)+40
        defw      race_raster+(8*333)+30
        defw      race_raster+(8*333)+73
        defw      race_raster+(8*333)+122
IF SPECMODEL=3
        defw      race_raster+(8*333)+164
ELSE
        defw      race_raster+(8*333)+86
ENDIF
        defw      race_raster+(8*333)+222
        defw      race_raster+(8*333)+260
        defw      race_raster+(8*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/19)*(3-9)*7)+40
        defw      race_raster+(9*333)+30
        defw      race_raster+(9*333)+73
        defw      race_raster+(9*333)+122
IF SPECMODEL=3
        defw      race_raster+(9*333)+164
ELSE
        defw      race_raster+(9*333)+86
ENDIF
        defw      race_raster+(9*333)+222
        defw      race_raster+(9*333)+260
        defw      race_raster+(9*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/19)*(3-10)*7)+40
        defw      race_raster+(10*333)+30
        defw      race_raster+(10*333)+73
        defw      race_raster+(10*333)+122
IF SPECMODEL=3
        defw      race_raster+(10*333)+164
ELSE
        defw      race_raster+(10*333)+86
ENDIF
        defw      race_raster+(10*333)+222
        defw      race_raster+(10*333)+260
        defw      race_raster+(10*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/19)*(3-11)*7)+40
        defw      race_raster+(11*333)+30
        defw      race_raster+(11*333)+73
        defw      race_raster+(11*333)+122
IF SPECMODEL=3
        defw      race_raster+(11*333)+164
ELSE
        defw      race_raster+(11*333)+86
ENDIF
        defw      race_raster+(11*333)+222
        defw      race_raster+(11*333)+260
        defw      race_raster+(11*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/19)*(3-12)*7)+40
        defw      race_raster+(12*333)+30
        defw      race_raster+(12*333)+73
        defw      race_raster+(12*333)+122
IF SPECMODEL=3
        defw      race_raster+(12*333)+164
ELSE
        defw      race_raster+(12*333)+86
ENDIF
        defw      race_raster+(12*333)+222
        defw      race_raster+(12*333)+260
        defw      race_raster+(12*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/19)*(3-13)*7)+40
        defw      race_raster+(13*333)+30
        defw      race_raster+(13*333)+73
        defw      race_raster+(13*333)+122
IF SPECMODEL=3
        defw      race_raster+(13*333)+164
ELSE
        defw      race_raster+(13*333)+86
ENDIF
        defw      race_raster+(13*333)+222
        defw      race_raster+(13*333)+260
        defw      race_raster+(13*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/19)*(3-14)*7)+40
        defw      race_raster+(14*333)+30
        defw      race_raster+(14*333)+73
        defw      race_raster+(14*333)+122
IF SPECMODEL=3
        defw      race_raster+(14*333)+164
ELSE
        defw      race_raster+(14*333)+86
ENDIF
        defw      race_raster+(14*333)+222
        defw      race_raster+(14*333)+260
        defw      race_raster+(14*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/19)*(3-15)*7)+40
        defw      race_raster+(15*333)+30
        defw      race_raster+(15*333)+73
        defw      race_raster+(15*333)+122
IF SPECMODEL=3
        defw      race_raster+(15*333)+164
ELSE
        defw      race_raster+(15*333)+86
ENDIF
        defw      race_raster+(15*333)+222
        defw      race_raster+(15*333)+260
        defw      race_raster+(15*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/19)*(3-16)*7)+40
        defw      race_raster+(16*333)+30
        defw      race_raster+(16*333)+73
        defw      race_raster+(16*333)+122
IF SPECMODEL=3
        defw      race_raster+(16*333)+164
ELSE
        defw      race_raster+(16*333)+86
ENDIF
        defw      race_raster+(16*333)+222
        defw      race_raster+(16*333)+260
        defw      race_raster+(16*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/19)*(3-17)*7)+40
        defw      race_raster+(17*333)+30
        defw      race_raster+(17*333)+73
        defw      race_raster+(17*333)+122
IF SPECMODEL=3
        defw      race_raster+(17*333)+164
ELSE
        defw      race_raster+(17*333)+86
ENDIF
        defw      race_raster+(17*333)+222
        defw      race_raster+(17*333)+260
        defw      race_raster+(17*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/19)*(3-18)*7)+40
        defw      race_raster+(18*333)+30
        defw      race_raster+(18*333)+73
        defw      race_raster+(18*333)+122
IF SPECMODEL=3
        defw      race_raster+(18*333)+164
ELSE
        defw      race_raster+(18*333)+86
ENDIF
        defw      race_raster+(18*333)+222
        defw      race_raster+(18*333)+260
        defw      race_raster+(18*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/19)*(3-19)*7)+40
        defw      race_raster+(19*333)+30
        defw      race_raster+(19*333)+73
        defw      race_raster+(19*333)+122
IF SPECMODEL=3
        defw      race_raster+(19*333)+164
ELSE
        defw      race_raster+(19*333)+86
ENDIF
        defw      race_raster+(19*333)+222
        defw      race_raster+(19*333)+260
        defw      race_raster+(19*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/19)*(3-20)*7)+40
        defw      race_raster+(20*333)+30
        defw      race_raster+(20*333)+73
        defw      race_raster+(20*333)+122
IF SPECMODEL=3
        defw      race_raster+(20*333)+164
ELSE
        defw      race_raster+(20*333)+86
ENDIF
        defw      race_raster+(20*333)+222
        defw      race_raster+(20*333)+260
        defw      race_raster+(20*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/19)*(3-21)*7)+40
        defw      race_raster+(21*333)+30
        defw      race_raster+(21*333)+73
        defw      race_raster+(21*333)+122
IF SPECMODEL=3
        defw      race_raster+(21*333)+164
ELSE
        defw      race_raster+(21*333)+86
ENDIF
        defw      race_raster+(21*333)+222
        defw      race_raster+(21*333)+260
        defw      race_raster+(21*333)+302
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 3 & 4

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/19)*(3-0)*7)+36
        defw      race_raster+(0*333)+26
        defw      race_raster+(0*333)+76
        defw      race_raster+(0*333)+125
        defw      race_raster+(0*333)+167
        defw      race_raster+(0*333)+211
        defw      race_raster+(0*333)+48
        defw      race_raster+(0*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/19)*(3-1)*7)+36
        defw      race_raster+(1*333)+26
        defw      race_raster+(1*333)+76
        defw      race_raster+(1*333)+125
        defw      race_raster+(1*333)+167
        defw      race_raster+(1*333)+211
        defw      race_raster+(1*333)+48
        defw      race_raster+(1*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/19)*(3-2)*7)+36
        defw      race_raster+(2*333)+26
        defw      race_raster+(2*333)+76
        defw      race_raster+(2*333)+125
        defw      race_raster+(2*333)+167
        defw      race_raster+(2*333)+211
        defw      race_raster+(2*333)+48
        defw      race_raster+(2*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/19)*(3-3)*7)+36
        defw      race_raster+(3*333)+26
        defw      race_raster+(3*333)+76
        defw      race_raster+(3*333)+125
        defw      race_raster+(3*333)+167
        defw      race_raster+(3*333)+211
        defw      race_raster+(3*333)+48
        defw      race_raster+(3*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/19)*(3-4)*7)+36
        defw      race_raster+(4*333)+26
        defw      race_raster+(4*333)+76
        defw      race_raster+(4*333)+125
        defw      race_raster+(4*333)+167
        defw      race_raster+(4*333)+211
        defw      race_raster+(4*333)+48
        defw      race_raster+(4*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/19)*(3-5)*7)+36
        defw      race_raster+(5*333)+26
        defw      race_raster+(5*333)+76
        defw      race_raster+(5*333)+125
        defw      race_raster+(5*333)+167
        defw      race_raster+(5*333)+211
        defw      race_raster+(5*333)+48
        defw      race_raster+(5*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/19)*(3-6)*7)+36
        defw      race_raster+(6*333)+26
        defw      race_raster+(6*333)+76
        defw      race_raster+(6*333)+125
        defw      race_raster+(6*333)+167
        defw      race_raster+(6*333)+211
        defw      race_raster+(6*333)+48
        defw      race_raster+(6*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/19)*(3-7)*7)+36
        defw      race_raster+(7*333)+26
        defw      race_raster+(7*333)+76
        defw      race_raster+(7*333)+125
        defw      race_raster+(7*333)+167
        defw      race_raster+(7*333)+211
        defw      race_raster+(7*333)+48
        defw      race_raster+(7*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/19)*(3-8)*7)+36
        defw      race_raster+(8*333)+26
        defw      race_raster+(8*333)+76
        defw      race_raster+(8*333)+125
        defw      race_raster+(8*333)+167
        defw      race_raster+(8*333)+211
        defw      race_raster+(8*333)+48
        defw      race_raster+(8*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/19)*(3-9)*7)+36
        defw      race_raster+(9*333)+26
        defw      race_raster+(9*333)+76
        defw      race_raster+(9*333)+125
        defw      race_raster+(9*333)+167
        defw      race_raster+(9*333)+211
        defw      race_raster+(9*333)+48
        defw      race_raster+(9*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/19)*(3-10)*7)+36
        defw      race_raster+(10*333)+26
        defw      race_raster+(10*333)+76
        defw      race_raster+(10*333)+125
        defw      race_raster+(10*333)+167
        defw      race_raster+(10*333)+211
        defw      race_raster+(10*333)+48
        defw      race_raster+(10*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/19)*(3-11)*7)+36
        defw      race_raster+(11*333)+26
        defw      race_raster+(11*333)+76
        defw      race_raster+(11*333)+125
        defw      race_raster+(11*333)+167
        defw      race_raster+(11*333)+211
        defw      race_raster+(11*333)+48
        defw      race_raster+(11*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/19)*(3-12)*7)+36
        defw      race_raster+(12*333)+26
        defw      race_raster+(12*333)+76
        defw      race_raster+(12*333)+125
        defw      race_raster+(12*333)+167
        defw      race_raster+(12*333)+211
        defw      race_raster+(12*333)+48
        defw      race_raster+(12*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/19)*(3-13)*7)+36
        defw      race_raster+(13*333)+26
        defw      race_raster+(13*333)+76
        defw      race_raster+(13*333)+125
        defw      race_raster+(13*333)+167
        defw      race_raster+(13*333)+211
        defw      race_raster+(13*333)+48
        defw      race_raster+(13*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/19)*(3-14)*7)+36
        defw      race_raster+(14*333)+26
        defw      race_raster+(14*333)+76
        defw      race_raster+(14*333)+125
        defw      race_raster+(14*333)+167
        defw      race_raster+(14*333)+211
        defw      race_raster+(14*333)+48
        defw      race_raster+(14*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/19)*(3-15)*7)+36
        defw      race_raster+(15*333)+26
        defw      race_raster+(15*333)+76
        defw      race_raster+(15*333)+125
        defw      race_raster+(15*333)+167
        defw      race_raster+(15*333)+211
        defw      race_raster+(15*333)+48
        defw      race_raster+(15*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/19)*(3-16)*7)+36
        defw      race_raster+(16*333)+26
        defw      race_raster+(16*333)+76
        defw      race_raster+(16*333)+125
        defw      race_raster+(16*333)+167
        defw      race_raster+(16*333)+211
        defw      race_raster+(16*333)+48
        defw      race_raster+(16*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/19)*(3-17)*7)+36
        defw      race_raster+(17*333)+26
        defw      race_raster+(17*333)+76
        defw      race_raster+(17*333)+125
        defw      race_raster+(17*333)+167
        defw      race_raster+(17*333)+211
        defw      race_raster+(17*333)+48
        defw      race_raster+(17*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/19)*(3-18)*7)+36
        defw      race_raster+(18*333)+26
        defw      race_raster+(18*333)+76
        defw      race_raster+(18*333)+125
        defw      race_raster+(18*333)+167
        defw      race_raster+(18*333)+211
        defw      race_raster+(18*333)+48
        defw      race_raster+(18*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/19)*(3-19)*7)+36
        defw      race_raster+(19*333)+26
        defw      race_raster+(19*333)+76
        defw      race_raster+(19*333)+125
        defw      race_raster+(19*333)+167
        defw      race_raster+(19*333)+211
        defw      race_raster+(19*333)+48
        defw      race_raster+(19*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/19)*(3-20)*7)+36
        defw      race_raster+(20*333)+26
        defw      race_raster+(20*333)+76
        defw      race_raster+(20*333)+125
        defw      race_raster+(20*333)+167
        defw      race_raster+(20*333)+211
        defw      race_raster+(20*333)+48
        defw      race_raster+(20*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/19)*(3-21)*7)+36
        defw      race_raster+(21*333)+26
        defw      race_raster+(21*333)+76
        defw      race_raster+(21*333)+125
        defw      race_raster+(21*333)+167
        defw      race_raster+(21*333)+211
        defw      race_raster+(21*333)+48
        defw      race_raster+(21*333)+305
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 5 & 6

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/19)*(3-0)*7)+30
        defw      race_raster+(0*333)+34
        defw      race_raster+(0*333)+79
        defw      race_raster+(0*333)+128
IF SPECMODEL=3
        defw      race_raster+(0*333)+83
ELSE
        defw      race_raster+(0*333)+170
ENDIF
        defw      race_raster+(0*333)+214
        defw      race_raster+(0*333)+256
        defw      race_raster+(0*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/19)*(3-1)*7)+30
        defw      race_raster+(1*333)+34
        defw      race_raster+(1*333)+79
        defw      race_raster+(1*333)+128
IF SPECMODEL=3
        defw      race_raster+(1*333)+83
ELSE
        defw      race_raster+(1*333)+170
ENDIF
        defw      race_raster+(1*333)+214
        defw      race_raster+(1*333)+256
        defw      race_raster+(1*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/19)*(3-2)*7)+30
        defw      race_raster+(2*333)+34
        defw      race_raster+(2*333)+79
        defw      race_raster+(2*333)+128
IF SPECMODEL=3
        defw      race_raster+(2*333)+83
ELSE
        defw      race_raster+(2*333)+170
ENDIF
        defw      race_raster+(2*333)+214
        defw      race_raster+(2*333)+256
        defw      race_raster+(2*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/19)*(3-3)*7)+30
        defw      race_raster+(3*333)+34
        defw      race_raster+(3*333)+79
        defw      race_raster+(3*333)+128
IF SPECMODEL=3
        defw      race_raster+(3*333)+83
ELSE
        defw      race_raster+(3*333)+170
ENDIF
        defw      race_raster+(3*333)+214
        defw      race_raster+(3*333)+256
        defw      race_raster+(3*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/19)*(3-4)*7)+30
        defw      race_raster+(4*333)+34
        defw      race_raster+(4*333)+79
        defw      race_raster+(4*333)+128
IF SPECMODEL=3
        defw      race_raster+(4*333)+83
ELSE
        defw      race_raster+(4*333)+170
ENDIF
        defw      race_raster+(4*333)+214
        defw      race_raster+(4*333)+256
        defw      race_raster+(4*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/19)*(3-5)*7)+30
        defw      race_raster+(5*333)+34
        defw      race_raster+(5*333)+79
        defw      race_raster+(5*333)+128
IF SPECMODEL=3
        defw      race_raster+(5*333)+83
ELSE
        defw      race_raster+(5*333)+170
ENDIF
        defw      race_raster+(5*333)+214
        defw      race_raster+(5*333)+256
        defw      race_raster+(5*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/19)*(3-6)*7)+30
        defw      race_raster+(6*333)+34
        defw      race_raster+(6*333)+79
        defw      race_raster+(6*333)+128
IF SPECMODEL=3
        defw      race_raster+(6*333)+83
ELSE
        defw      race_raster+(6*333)+170
ENDIF
        defw      race_raster+(6*333)+214
        defw      race_raster+(6*333)+256
        defw      race_raster+(6*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/19)*(3-7)*7)+30
        defw      race_raster+(7*333)+34
        defw      race_raster+(7*333)+79
        defw      race_raster+(7*333)+128
IF SPECMODEL=3
        defw      race_raster+(7*333)+83
ELSE
        defw      race_raster+(7*333)+170
ENDIF
        defw      race_raster+(7*333)+214
        defw      race_raster+(7*333)+256
        defw      race_raster+(7*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/19)*(3-8)*7)+30
        defw      race_raster+(8*333)+34
        defw      race_raster+(8*333)+79
        defw      race_raster+(8*333)+128
IF SPECMODEL=3
        defw      race_raster+(8*333)+83
ELSE
        defw      race_raster+(8*333)+170
ENDIF
        defw      race_raster+(8*333)+214
        defw      race_raster+(8*333)+256
        defw      race_raster+(8*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/19)*(3-9)*7)+30
        defw      race_raster+(9*333)+34
        defw      race_raster+(9*333)+79
        defw      race_raster+(9*333)+128
IF SPECMODEL=3
        defw      race_raster+(9*333)+83
ELSE
        defw      race_raster+(9*333)+170
ENDIF
        defw      race_raster+(9*333)+214
        defw      race_raster+(9*333)+256
        defw      race_raster+(9*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/19)*(3-10)*7)+30
        defw      race_raster+(10*333)+34
        defw      race_raster+(10*333)+79
        defw      race_raster+(10*333)+128
IF SPECMODEL=3
        defw      race_raster+(10*333)+83
ELSE
        defw      race_raster+(10*333)+170
ENDIF
        defw      race_raster+(10*333)+214
        defw      race_raster+(10*333)+256
        defw      race_raster+(10*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/19)*(3-11)*7)+30
        defw      race_raster+(11*333)+34
        defw      race_raster+(11*333)+79
        defw      race_raster+(11*333)+128
IF SPECMODEL=3
        defw      race_raster+(11*333)+83
ELSE
        defw      race_raster+(11*333)+170
ENDIF
        defw      race_raster+(11*333)+214
        defw      race_raster+(11*333)+256
        defw      race_raster+(11*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/19)*(3-12)*7)+30
        defw      race_raster+(12*333)+34
        defw      race_raster+(12*333)+79
        defw      race_raster+(12*333)+128
IF SPECMODEL=3
        defw      race_raster+(12*333)+83
ELSE
        defw      race_raster+(12*333)+170
ENDIF
        defw      race_raster+(12*333)+214
        defw      race_raster+(12*333)+256
        defw      race_raster+(12*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/19)*(3-13)*7)+30
        defw      race_raster+(13*333)+34
        defw      race_raster+(13*333)+79
        defw      race_raster+(13*333)+128
IF SPECMODEL=3
        defw      race_raster+(13*333)+83
ELSE
        defw      race_raster+(13*333)+170
ENDIF
        defw      race_raster+(13*333)+214
        defw      race_raster+(13*333)+256
        defw      race_raster+(13*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/19)*(3-14)*7)+30
        defw      race_raster+(14*333)+34
        defw      race_raster+(14*333)+79
        defw      race_raster+(14*333)+128
IF SPECMODEL=3
        defw      race_raster+(14*333)+83
ELSE
        defw      race_raster+(14*333)+170
ENDIF
        defw      race_raster+(14*333)+214
        defw      race_raster+(14*333)+256
        defw      race_raster+(14*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/19)*(3-15)*7)+30
        defw      race_raster+(15*333)+34
        defw      race_raster+(15*333)+79
        defw      race_raster+(15*333)+128
IF SPECMODEL=3
        defw      race_raster+(15*333)+83
ELSE
        defw      race_raster+(15*333)+170
ENDIF
        defw      race_raster+(15*333)+214
        defw      race_raster+(15*333)+256
        defw      race_raster+(15*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/19)*(3-16)*7)+30
        defw      race_raster+(16*333)+34
        defw      race_raster+(16*333)+79
        defw      race_raster+(16*333)+128
IF SPECMODEL=3
        defw      race_raster+(16*333)+83
ELSE
        defw      race_raster+(16*333)+170
ENDIF
        defw      race_raster+(16*333)+214
        defw      race_raster+(16*333)+256
        defw      race_raster+(16*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/19)*(3-17)*7)+30
        defw      race_raster+(17*333)+34
        defw      race_raster+(17*333)+79
        defw      race_raster+(17*333)+128
IF SPECMODEL=3
        defw      race_raster+(17*333)+83
ELSE
        defw      race_raster+(17*333)+170
ENDIF
        defw      race_raster+(17*333)+214
        defw      race_raster+(17*333)+256
        defw      race_raster+(17*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/19)*(3-18)*7)+30
        defw      race_raster+(18*333)+34
        defw      race_raster+(18*333)+79
        defw      race_raster+(18*333)+128
IF SPECMODEL=3
        defw      race_raster+(18*333)+83
ELSE
        defw      race_raster+(18*333)+170
ENDIF
        defw      race_raster+(18*333)+214
        defw      race_raster+(18*333)+256
        defw      race_raster+(18*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/19)*(3-19)*7)+30
        defw      race_raster+(19*333)+34
        defw      race_raster+(19*333)+79
        defw      race_raster+(19*333)+128
IF SPECMODEL=3
        defw      race_raster+(19*333)+83
ELSE
        defw      race_raster+(19*333)+170
ENDIF
        defw      race_raster+(19*333)+214
        defw      race_raster+(19*333)+256
        defw      race_raster+(19*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/19)*(3-20)*7)+30
        defw      race_raster+(20*333)+34
        defw      race_raster+(20*333)+79
        defw      race_raster+(20*333)+128
IF SPECMODEL=3
        defw      race_raster+(20*333)+83
ELSE
        defw      race_raster+(20*333)+170
ENDIF
        defw      race_raster+(20*333)+214
        defw      race_raster+(20*333)+256
        defw      race_raster+(20*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/19)*(3-21)*7)+30
        defw      race_raster+(21*333)+34
        defw      race_raster+(21*333)+79
        defw      race_raster+(21*333)+128
IF SPECMODEL=3
        defw      race_raster+(21*333)+83
ELSE
        defw      race_raster+(21*333)+170
ENDIF
        defw      race_raster+(21*333)+214
        defw      race_raster+(21*333)+256
        defw      race_raster+(21*333)+295
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 7 & 8

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/19)*(3-0)*7)+27
        defw      race_raster+(0*333)+61
        defw      race_raster+(0*333)+108
        defw      extra_buffer+(0*4)+2
        defw      race_raster+(0*333)+193
        defw      race_raster+(0*333)+236
        defw      race_raster+(0*333)+278
        defw      race_raster+(0*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/19)*(3-1)*7)+27
        defw      race_raster+(1*333)+61
        defw      race_raster+(1*333)+108
        defw      extra_buffer+(1*4)+2
        defw      race_raster+(1*333)+193
        defw      race_raster+(1*333)+236
        defw      race_raster+(1*333)+278
        defw      race_raster+(1*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/19)*(3-2)*7)+27
        defw      race_raster+(2*333)+61
        defw      race_raster+(2*333)+108
        defw      extra_buffer+(2*4)+2
        defw      race_raster+(2*333)+193
        defw      race_raster+(2*333)+236
        defw      race_raster+(2*333)+278
        defw      race_raster+(2*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/19)*(3-3)*7)+27
        defw      race_raster+(3*333)+61
        defw      race_raster+(3*333)+108
        defw      extra_buffer+(3*4)+2
        defw      race_raster+(3*333)+193
        defw      race_raster+(3*333)+236
        defw      race_raster+(3*333)+278
        defw      race_raster+(3*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/19)*(3-4)*7)+27
        defw      race_raster+(4*333)+61
        defw      race_raster+(4*333)+108
        defw      extra_buffer+(4*4)+2
        defw      race_raster+(4*333)+193
        defw      race_raster+(4*333)+236
        defw      race_raster+(4*333)+278
        defw      race_raster+(4*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/19)*(3-5)*7)+27
        defw      race_raster+(5*333)+61
        defw      race_raster+(5*333)+108
        defw      extra_buffer+(5*4)+2
        defw      race_raster+(5*333)+193
        defw      race_raster+(5*333)+236
        defw      race_raster+(5*333)+278
        defw      race_raster+(5*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/19)*(3-6)*7)+27
        defw      race_raster+(6*333)+61
        defw      race_raster+(6*333)+108
        defw      extra_buffer+(6*4)+2
        defw      race_raster+(6*333)+193
        defw      race_raster+(6*333)+236
        defw      race_raster+(6*333)+278
        defw      race_raster+(6*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/19)*(3-7)*7)+27
        defw      race_raster+(7*333)+61
        defw      race_raster+(7*333)+108
        defw      extra_buffer+(7*4)+2
        defw      race_raster+(7*333)+193
        defw      race_raster+(7*333)+236
        defw      race_raster+(7*333)+278
        defw      race_raster+(7*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/19)*(3-8)*7)+27
        defw      race_raster+(8*333)+61
        defw      race_raster+(8*333)+108
        defw      extra_buffer+(8*4)+2
        defw      race_raster+(8*333)+193
        defw      race_raster+(8*333)+236
        defw      race_raster+(8*333)+278
        defw      race_raster+(8*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/19)*(3-9)*7)+27
        defw      race_raster+(9*333)+61
        defw      race_raster+(9*333)+108
        defw      extra_buffer+(9*4)+2
        defw      race_raster+(9*333)+193
        defw      race_raster+(9*333)+236
        defw      race_raster+(9*333)+278
        defw      race_raster+(9*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/19)*(3-10)*7)+27
        defw      race_raster+(10*333)+61
        defw      race_raster+(10*333)+108
        defw      extra_buffer+(10*4)+2
        defw      race_raster+(10*333)+193
        defw      race_raster+(10*333)+236
        defw      race_raster+(10*333)+278
        defw      race_raster+(10*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/19)*(3-11)*7)+27
        defw      race_raster+(11*333)+61
        defw      race_raster+(11*333)+108
        defw      extra_buffer+(11*4)+2
        defw      race_raster+(11*333)+193
        defw      race_raster+(11*333)+236
        defw      race_raster+(11*333)+278
        defw      race_raster+(11*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/19)*(3-12)*7)+27
        defw      race_raster+(12*333)+61
        defw      race_raster+(12*333)+108
        defw      extra_buffer+(12*4)+2
        defw      race_raster+(12*333)+193
        defw      race_raster+(12*333)+236
        defw      race_raster+(12*333)+278
        defw      race_raster+(12*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/19)*(3-13)*7)+27
        defw      race_raster+(13*333)+61
        defw      race_raster+(13*333)+108
        defw      extra_buffer+(13*4)+2
        defw      race_raster+(13*333)+193
        defw      race_raster+(13*333)+236
        defw      race_raster+(13*333)+278
        defw      race_raster+(13*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/19)*(3-14)*7)+27
        defw      race_raster+(14*333)+61
        defw      race_raster+(14*333)+108
        defw      extra_buffer+(14*4)+2
        defw      race_raster+(14*333)+193
        defw      race_raster+(14*333)+236
        defw      race_raster+(14*333)+278
        defw      race_raster+(14*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/19)*(3-15)*7)+27
        defw      race_raster+(15*333)+61
        defw      race_raster+(15*333)+108
        defw      extra_buffer+(15*4)+2
        defw      race_raster+(15*333)+193
        defw      race_raster+(15*333)+236
        defw      race_raster+(15*333)+278
        defw      race_raster+(15*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/19)*(3-16)*7)+27
        defw      race_raster+(16*333)+61
        defw      race_raster+(16*333)+108
        defw      extra_buffer+(16*4)+2
        defw      race_raster+(16*333)+193
        defw      race_raster+(16*333)+236
        defw      race_raster+(16*333)+278
        defw      race_raster+(16*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/19)*(3-17)*7)+27
        defw      race_raster+(17*333)+61
        defw      race_raster+(17*333)+108
        defw      extra_buffer+(17*4)+2
        defw      race_raster+(17*333)+193
        defw      race_raster+(17*333)+236
        defw      race_raster+(17*333)+278
        defw      race_raster+(17*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/19)*(3-18)*7)+27
        defw      race_raster+(18*333)+61
        defw      race_raster+(18*333)+108
        defw      extra_buffer+(18*4)+2
        defw      race_raster+(18*333)+193
        defw      race_raster+(18*333)+236
        defw      race_raster+(18*333)+278
        defw      race_raster+(18*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/19)*(3-19)*7)+27
        defw      race_raster+(19*333)+61
        defw      race_raster+(19*333)+108
        defw      extra_buffer+(19*4)+2
        defw      race_raster+(19*333)+193
        defw      race_raster+(19*333)+236
        defw      race_raster+(19*333)+278
        defw      race_raster+(19*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/19)*(3-20)*7)+27
        defw      race_raster+(20*333)+61
        defw      race_raster+(20*333)+108
        defw      extra_buffer+(20*4)+2
        defw      race_raster+(20*333)+193
        defw      race_raster+(20*333)+236
        defw      race_raster+(20*333)+278
        defw      race_raster+(20*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/19)*(3-21)*7)+27
        defw      race_raster+(21*333)+61
        defw      race_raster+(21*333)+108
        defw      extra_buffer+(21*4)+2
        defw      race_raster+(21*333)+193
        defw      race_raster+(21*333)+236
        defw      race_raster+(21*333)+278
        defw      race_raster+(21*333)+318
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 9 & 10

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/19)*(3-0)*7)+24
        defw      race_raster+(0*333)+64
        defw      race_raster+(0*333)+10
        defw      race_raster+(0*333)+112
        defw      race_raster+(0*333)+154
        defw      extra_buffer+(0*4)
        defw      race_raster+(0*333)+240
        defw      race_raster+(0*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/19)*(3-1)*7)+24
        defw      race_raster+(1*333)+64
        defw      race_raster+(1*333)+10
        defw      race_raster+(1*333)+112
        defw      race_raster+(1*333)+154
        defw      extra_buffer+(1*4)
        defw      race_raster+(1*333)+240
        defw      race_raster+(1*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/19)*(3-2)*7)+24
        defw      race_raster+(2*333)+64
        defw      race_raster+(2*333)+10
        defw      race_raster+(2*333)+112
        defw      race_raster+(2*333)+154
        defw      extra_buffer+(2*4)
        defw      race_raster+(2*333)+240
        defw      race_raster+(2*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/19)*(3-3)*7)+24
        defw      race_raster+(3*333)+64
        defw      race_raster+(3*333)+10
        defw      race_raster+(3*333)+112
        defw      race_raster+(3*333)+154
        defw      extra_buffer+(3*4)
        defw      race_raster+(3*333)+240
        defw      race_raster+(3*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/19)*(3-4)*7)+24
        defw      race_raster+(4*333)+64
        defw      race_raster+(4*333)+10
        defw      race_raster+(4*333)+112
        defw      race_raster+(4*333)+154
        defw      extra_buffer+(4*4)
        defw      race_raster+(4*333)+240
        defw      race_raster+(4*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/19)*(3-5)*7)+24
        defw      race_raster+(5*333)+64
        defw      race_raster+(5*333)+10
        defw      race_raster+(5*333)+112
        defw      race_raster+(5*333)+154
        defw      extra_buffer+(5*4)
        defw      race_raster+(5*333)+240
        defw      race_raster+(5*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/19)*(3-6)*7)+24
        defw      race_raster+(6*333)+64
        defw      race_raster+(6*333)+10
        defw      race_raster+(6*333)+112
        defw      race_raster+(6*333)+154
        defw      extra_buffer+(6*4)
        defw      race_raster+(6*333)+240
        defw      race_raster+(6*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/19)*(3-7)*7)+24
        defw      race_raster+(7*333)+64
        defw      race_raster+(7*333)+10
        defw      race_raster+(7*333)+112
        defw      race_raster+(7*333)+154
        defw      extra_buffer+(7*4)
        defw      race_raster+(7*333)+240
        defw      race_raster+(7*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/19)*(3-8)*7)+24
        defw      race_raster+(8*333)+64
        defw      race_raster+(8*333)+10
        defw      race_raster+(8*333)+112
        defw      race_raster+(8*333)+154
        defw      extra_buffer+(8*4)
        defw      race_raster+(8*333)+240
        defw      race_raster+(8*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/19)*(3-9)*7)+24
        defw      race_raster+(9*333)+64
        defw      race_raster+(9*333)+10
        defw      race_raster+(9*333)+112
        defw      race_raster+(9*333)+154
        defw      extra_buffer+(9*4)
        defw      race_raster+(9*333)+240
        defw      race_raster+(9*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/19)*(3-10)*7)+24
        defw      race_raster+(10*333)+64
        defw      race_raster+(10*333)+10
        defw      race_raster+(10*333)+112
        defw      race_raster+(10*333)+154
        defw      extra_buffer+(10*4)
        defw      race_raster+(10*333)+240
        defw      race_raster+(10*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/19)*(3-11)*7)+24
        defw      race_raster+(11*333)+64
        defw      race_raster+(11*333)+10
        defw      race_raster+(11*333)+112
        defw      race_raster+(11*333)+154
        defw      extra_buffer+(11*4)
        defw      race_raster+(11*333)+240
        defw      race_raster+(11*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/19)*(3-12)*7)+24
        defw      race_raster+(12*333)+64
        defw      race_raster+(12*333)+10
        defw      race_raster+(12*333)+112
        defw      race_raster+(12*333)+154
        defw      extra_buffer+(12*4)
        defw      race_raster+(12*333)+240
        defw      race_raster+(12*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/19)*(3-13)*7)+24
        defw      race_raster+(13*333)+64
        defw      race_raster+(13*333)+10
        defw      race_raster+(13*333)+112
        defw      race_raster+(13*333)+154
        defw      extra_buffer+(13*4)
        defw      race_raster+(13*333)+240
        defw      race_raster+(13*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/19)*(3-14)*7)+24
        defw      race_raster+(14*333)+64
        defw      race_raster+(14*333)+10
        defw      race_raster+(14*333)+112
        defw      race_raster+(14*333)+154
        defw      extra_buffer+(14*4)
        defw      race_raster+(14*333)+240
        defw      race_raster+(14*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/19)*(3-15)*7)+24
        defw      race_raster+(15*333)+64
        defw      race_raster+(15*333)+10
        defw      race_raster+(15*333)+112
        defw      race_raster+(15*333)+154
        defw      extra_buffer+(15*4)
        defw      race_raster+(15*333)+240
        defw      race_raster+(15*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/19)*(3-16)*7)+24
        defw      race_raster+(16*333)+64
        defw      race_raster+(16*333)+10
        defw      race_raster+(16*333)+112
        defw      race_raster+(16*333)+154
        defw      extra_buffer+(16*4)
        defw      race_raster+(16*333)+240
        defw      race_raster+(16*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/19)*(3-17)*7)+24
        defw      race_raster+(17*333)+64
        defw      race_raster+(17*333)+10
        defw      race_raster+(17*333)+112
        defw      race_raster+(17*333)+154
        defw      extra_buffer+(17*4)
        defw      race_raster+(17*333)+240
        defw      race_raster+(17*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/19)*(3-18)*7)+24
        defw      race_raster+(18*333)+64
        defw      race_raster+(18*333)+10
        defw      race_raster+(18*333)+112
        defw      race_raster+(18*333)+154
        defw      extra_buffer+(18*4)
        defw      race_raster+(18*333)+240
        defw      race_raster+(18*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/19)*(3-19)*7)+24
        defw      race_raster+(19*333)+64
        defw      race_raster+(19*333)+10
        defw      race_raster+(19*333)+112
        defw      race_raster+(19*333)+154
        defw      extra_buffer+(19*4)
        defw      race_raster+(19*333)+240
        defw      race_raster+(19*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/19)*(3-20)*7)+24
        defw      race_raster+(20*333)+64
        defw      race_raster+(20*333)+10
        defw      race_raster+(20*333)+112
        defw      race_raster+(20*333)+154
        defw      extra_buffer+(20*4)
        defw      race_raster+(20*333)+240
        defw      race_raster+(20*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/19)*(3-21)*7)+24
        defw      race_raster+(21*333)+64
        defw      race_raster+(21*333)+10
        defw      race_raster+(21*333)+112
        defw      race_raster+(21*333)+154
        defw      extra_buffer+(21*4)
        defw      race_raster+(21*333)+240
        defw      race_raster+(21*333)+291
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 11 & 12

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/20)*(2-0)*7)+(((21-0)/19)*4)+20
        defw      race_raster+(0*333)+67
        defw      race_raster+(0*333)+13
        defw      race_raster+(0*333)+115
        defw      race_raster+(0*333)+157
        defw      race_raster+(0*333)+198
        defw      race_raster+(0*333)+243
        defw      race_raster+(0*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/20)*(2-1)*7)+(((21-1)/19)*4)+20
        defw      race_raster+(1*333)+67
        defw      race_raster+(1*333)+13
        defw      race_raster+(1*333)+115
        defw      race_raster+(1*333)+157
        defw      race_raster+(1*333)+198
        defw      race_raster+(1*333)+243
        defw      race_raster+(1*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/20)*(2-2)*7)+(((21-2)/19)*4)+20
        defw      race_raster+(2*333)+67
        defw      race_raster+(2*333)+13
        defw      race_raster+(2*333)+115
        defw      race_raster+(2*333)+157
        defw      race_raster+(2*333)+198
        defw      race_raster+(2*333)+243
        defw      race_raster+(2*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/20)*(2-3)*7)+(((21-3)/19)*4)+20
        defw      race_raster+(3*333)+67
        defw      race_raster+(3*333)+13
        defw      race_raster+(3*333)+115
        defw      race_raster+(3*333)+157
        defw      race_raster+(3*333)+198
        defw      race_raster+(3*333)+243
        defw      race_raster+(3*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/20)*(2-4)*7)+(((21-4)/19)*4)+20
        defw      race_raster+(4*333)+67
        defw      race_raster+(4*333)+13
        defw      race_raster+(4*333)+115
        defw      race_raster+(4*333)+157
        defw      race_raster+(4*333)+198
        defw      race_raster+(4*333)+243
        defw      race_raster+(4*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/20)*(2-5)*7)+(((21-5)/19)*4)+20
        defw      race_raster+(5*333)+67
        defw      race_raster+(5*333)+13
        defw      race_raster+(5*333)+115
        defw      race_raster+(5*333)+157
        defw      race_raster+(5*333)+198
        defw      race_raster+(5*333)+243
        defw      race_raster+(5*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/20)*(2-6)*7)+(((21-6)/19)*4)+20
        defw      race_raster+(6*333)+67
        defw      race_raster+(6*333)+13
        defw      race_raster+(6*333)+115
        defw      race_raster+(6*333)+157
        defw      race_raster+(6*333)+198
        defw      race_raster+(6*333)+243
        defw      race_raster+(6*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/20)*(2-7)*7)+(((21-7)/19)*4)+20
        defw      race_raster+(7*333)+67
        defw      race_raster+(7*333)+13
        defw      race_raster+(7*333)+115
        defw      race_raster+(7*333)+157
        defw      race_raster+(7*333)+198
        defw      race_raster+(7*333)+243
        defw      race_raster+(7*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/20)*(2-8)*7)+(((21-8)/19)*4)+20
        defw      race_raster+(8*333)+67
        defw      race_raster+(8*333)+13
        defw      race_raster+(8*333)+115
        defw      race_raster+(8*333)+157
        defw      race_raster+(8*333)+198
        defw      race_raster+(8*333)+243
        defw      race_raster+(8*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/20)*(2-9)*7)+(((21-9)/19)*4)+20
        defw      race_raster+(9*333)+67
        defw      race_raster+(9*333)+13
        defw      race_raster+(9*333)+115
        defw      race_raster+(9*333)+157
        defw      race_raster+(9*333)+198
        defw      race_raster+(9*333)+243
        defw      race_raster+(9*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/20)*(2-10)*7)+(((21-10)/19)*4)+20
        defw      race_raster+(10*333)+67
        defw      race_raster+(10*333)+13
        defw      race_raster+(10*333)+115
        defw      race_raster+(10*333)+157
        defw      race_raster+(10*333)+198
        defw      race_raster+(10*333)+243
        defw      race_raster+(10*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/20)*(2-11)*7)+(((21-11)/19)*4)+20
        defw      race_raster+(11*333)+67
        defw      race_raster+(11*333)+13
        defw      race_raster+(11*333)+115
        defw      race_raster+(11*333)+157
        defw      race_raster+(11*333)+198
        defw      race_raster+(11*333)+243
        defw      race_raster+(11*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/20)*(2-12)*7)+(((21-12)/19)*4)+20
        defw      race_raster+(12*333)+67
        defw      race_raster+(12*333)+13
        defw      race_raster+(12*333)+115
        defw      race_raster+(12*333)+157
        defw      race_raster+(12*333)+198
        defw      race_raster+(12*333)+243
        defw      race_raster+(12*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/20)*(2-13)*7)+(((21-13)/19)*4)+20
        defw      race_raster+(13*333)+67
        defw      race_raster+(13*333)+13
        defw      race_raster+(13*333)+115
        defw      race_raster+(13*333)+157
        defw      race_raster+(13*333)+198
        defw      race_raster+(13*333)+243
        defw      race_raster+(13*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/20)*(2-14)*7)+(((21-14)/19)*4)+20
        defw      race_raster+(14*333)+67
        defw      race_raster+(14*333)+13
        defw      race_raster+(14*333)+115
        defw      race_raster+(14*333)+157
        defw      race_raster+(14*333)+198
        defw      race_raster+(14*333)+243
        defw      race_raster+(14*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/20)*(2-15)*7)+(((21-15)/19)*4)+20
        defw      race_raster+(15*333)+67
        defw      race_raster+(15*333)+13
        defw      race_raster+(15*333)+115
        defw      race_raster+(15*333)+157
        defw      race_raster+(15*333)+198
        defw      race_raster+(15*333)+243
        defw      race_raster+(15*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/20)*(2-16)*7)+(((21-16)/19)*4)+20
        defw      race_raster+(16*333)+67
        defw      race_raster+(16*333)+13
        defw      race_raster+(16*333)+115
        defw      race_raster+(16*333)+157
        defw      race_raster+(16*333)+198
        defw      race_raster+(16*333)+243
        defw      race_raster+(16*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/20)*(2-17)*7)+(((21-17)/19)*4)+20
        defw      race_raster+(17*333)+67
        defw      race_raster+(17*333)+13
        defw      race_raster+(17*333)+115
        defw      race_raster+(17*333)+157
        defw      race_raster+(17*333)+198
        defw      race_raster+(17*333)+243
        defw      race_raster+(17*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/20)*(2-18)*7)+(((21-18)/19)*4)+20
        defw      race_raster+(18*333)+67
        defw      race_raster+(18*333)+13
        defw      race_raster+(18*333)+115
        defw      race_raster+(18*333)+157
        defw      race_raster+(18*333)+198
        defw      race_raster+(18*333)+243
        defw      race_raster+(18*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/20)*(2-19)*7)+(((21-19)/19)*4)+20
        defw      race_raster+(19*333)+67
        defw      race_raster+(19*333)+13
        defw      race_raster+(19*333)+115
        defw      race_raster+(19*333)+157
        defw      race_raster+(19*333)+198
        defw      race_raster+(19*333)+243
        defw      race_raster+(19*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/20)*(2-20)*7)+(((21-20)/19)*4)+20
        defw      race_raster+(20*333)+67
        defw      race_raster+(20*333)+13
        defw      race_raster+(20*333)+115
        defw      race_raster+(20*333)+157
        defw      race_raster+(20*333)+198
        defw      race_raster+(20*333)+243
        defw      race_raster+(20*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/20)*(2-21)*7)+(((21-21)/19)*4)+20
        defw      race_raster+(21*333)+67
        defw      race_raster+(21*333)+13
        defw      race_raster+(21*333)+115
        defw      race_raster+(21*333)+157
        defw      race_raster+(21*333)+198
        defw      race_raster+(21*333)+243
        defw      race_raster+(21*333)+282
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 13 & 14

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/20)*(2-0)*7)+(((21-0)/19)*4)+16
        defw      race_raster+(0*333)+20
        defw      race_raster+(0*333)+16
        defw      race_raster+(0*333)+118
        defw      race_raster+(0*333)+160
        defw      race_raster+(0*333)+201
        defw      race_raster+(0*333)+246
        defw      race_raster+(0*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/20)*(2-1)*7)+(((21-1)/19)*4)+16
        defw      race_raster+(1*333)+20
        defw      race_raster+(1*333)+16
        defw      race_raster+(1*333)+118
        defw      race_raster+(1*333)+160
        defw      race_raster+(1*333)+201
        defw      race_raster+(1*333)+246
        defw      race_raster+(1*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/20)*(2-2)*7)+(((21-2)/19)*4)+16
        defw      race_raster+(2*333)+20
        defw      race_raster+(2*333)+16
        defw      race_raster+(2*333)+118
        defw      race_raster+(2*333)+160
        defw      race_raster+(2*333)+201
        defw      race_raster+(2*333)+246
        defw      race_raster+(2*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/20)*(2-3)*7)+(((21-3)/19)*4)+16
        defw      race_raster+(3*333)+20
        defw      race_raster+(3*333)+16
        defw      race_raster+(3*333)+118
        defw      race_raster+(3*333)+160
        defw      race_raster+(3*333)+201
        defw      race_raster+(3*333)+246
        defw      race_raster+(3*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/20)*(2-4)*7)+(((21-4)/19)*4)+16
        defw      race_raster+(4*333)+20
        defw      race_raster+(4*333)+16
        defw      race_raster+(4*333)+118
        defw      race_raster+(4*333)+160
        defw      race_raster+(4*333)+201
        defw      race_raster+(4*333)+246
        defw      race_raster+(4*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/20)*(2-5)*7)+(((21-5)/19)*4)+16
        defw      race_raster+(5*333)+20
        defw      race_raster+(5*333)+16
        defw      race_raster+(5*333)+118
        defw      race_raster+(5*333)+160
        defw      race_raster+(5*333)+201
        defw      race_raster+(5*333)+246
        defw      race_raster+(5*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/20)*(2-6)*7)+(((21-6)/19)*4)+16
        defw      race_raster+(6*333)+20
        defw      race_raster+(6*333)+16
        defw      race_raster+(6*333)+118
        defw      race_raster+(6*333)+160
        defw      race_raster+(6*333)+201
        defw      race_raster+(6*333)+246
        defw      race_raster+(6*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/20)*(2-7)*7)+(((21-7)/19)*4)+16
        defw      race_raster+(7*333)+20
        defw      race_raster+(7*333)+16
        defw      race_raster+(7*333)+118
        defw      race_raster+(7*333)+160
        defw      race_raster+(7*333)+201
        defw      race_raster+(7*333)+246
        defw      race_raster+(7*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/20)*(2-8)*7)+(((21-8)/19)*4)+16
        defw      race_raster+(8*333)+20
        defw      race_raster+(8*333)+16
        defw      race_raster+(8*333)+118
        defw      race_raster+(8*333)+160
        defw      race_raster+(8*333)+201
        defw      race_raster+(8*333)+246
        defw      race_raster+(8*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/20)*(2-9)*7)+(((21-9)/19)*4)+16
        defw      race_raster+(9*333)+20
        defw      race_raster+(9*333)+16
        defw      race_raster+(9*333)+118
        defw      race_raster+(9*333)+160
        defw      race_raster+(9*333)+201
        defw      race_raster+(9*333)+246
        defw      race_raster+(9*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/20)*(2-10)*7)+(((21-10)/19)*4)+16
        defw      race_raster+(10*333)+20
        defw      race_raster+(10*333)+16
        defw      race_raster+(10*333)+118
        defw      race_raster+(10*333)+160
        defw      race_raster+(10*333)+201
        defw      race_raster+(10*333)+246
        defw      race_raster+(10*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/20)*(2-11)*7)+(((21-11)/19)*4)+16
        defw      race_raster+(11*333)+20
        defw      race_raster+(11*333)+16
        defw      race_raster+(11*333)+118
        defw      race_raster+(11*333)+160
        defw      race_raster+(11*333)+201
        defw      race_raster+(11*333)+246
        defw      race_raster+(11*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/20)*(2-12)*7)+(((21-12)/19)*4)+16
        defw      race_raster+(12*333)+20
        defw      race_raster+(12*333)+16
        defw      race_raster+(12*333)+118
        defw      race_raster+(12*333)+160
        defw      race_raster+(12*333)+201
        defw      race_raster+(12*333)+246
        defw      race_raster+(12*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/20)*(2-13)*7)+(((21-13)/19)*4)+16
        defw      race_raster+(13*333)+20
        defw      race_raster+(13*333)+16
        defw      race_raster+(13*333)+118
        defw      race_raster+(13*333)+160
        defw      race_raster+(13*333)+201
        defw      race_raster+(13*333)+246
        defw      race_raster+(13*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/20)*(2-14)*7)+(((21-14)/19)*4)+16
        defw      race_raster+(14*333)+20
        defw      race_raster+(14*333)+16
        defw      race_raster+(14*333)+118
        defw      race_raster+(14*333)+160
        defw      race_raster+(14*333)+201
        defw      race_raster+(14*333)+246
        defw      race_raster+(14*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/20)*(2-15)*7)+(((21-15)/19)*4)+16
        defw      race_raster+(15*333)+20
        defw      race_raster+(15*333)+16
        defw      race_raster+(15*333)+118
        defw      race_raster+(15*333)+160
        defw      race_raster+(15*333)+201
        defw      race_raster+(15*333)+246
        defw      race_raster+(15*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/20)*(2-16)*7)+(((21-16)/19)*4)+16
        defw      race_raster+(16*333)+20
        defw      race_raster+(16*333)+16
        defw      race_raster+(16*333)+118
        defw      race_raster+(16*333)+160
        defw      race_raster+(16*333)+201
        defw      race_raster+(16*333)+246
        defw      race_raster+(16*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/20)*(2-17)*7)+(((21-17)/19)*4)+16
        defw      race_raster+(17*333)+20
        defw      race_raster+(17*333)+16
        defw      race_raster+(17*333)+118
        defw      race_raster+(17*333)+160
        defw      race_raster+(17*333)+201
        defw      race_raster+(17*333)+246
        defw      race_raster+(17*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/20)*(2-18)*7)+(((21-18)/19)*4)+16
        defw      race_raster+(18*333)+20
        defw      race_raster+(18*333)+16
        defw      race_raster+(18*333)+118
        defw      race_raster+(18*333)+160
        defw      race_raster+(18*333)+201
        defw      race_raster+(18*333)+246
        defw      race_raster+(18*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/20)*(2-19)*7)+(((21-19)/19)*4)+16
        defw      race_raster+(19*333)+20
        defw      race_raster+(19*333)+16
        defw      race_raster+(19*333)+118
        defw      race_raster+(19*333)+160
        defw      race_raster+(19*333)+201
        defw      race_raster+(19*333)+246
        defw      race_raster+(19*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/20)*(2-20)*7)+(((21-20)/19)*4)+16
        defw      race_raster+(20*333)+20
        defw      race_raster+(20*333)+16
        defw      race_raster+(20*333)+118
        defw      race_raster+(20*333)+160
        defw      race_raster+(20*333)+201
        defw      race_raster+(20*333)+246
        defw      race_raster+(20*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/20)*(2-21)*7)+(((21-21)/19)*4)+16
        defw      race_raster+(21*333)+20
        defw      race_raster+(21*333)+16
        defw      race_raster+(21*333)+118
        defw      race_raster+(21*333)+160
        defw      race_raster+(21*333)+201
        defw      race_raster+(21*333)+246
        defw      race_raster+(21*333)+285
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 15 & 16

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/20)*(2-0)*7)+(((21-0)/19)*4)+10
        defw      race_raster+(0*333)+52
        defw      race_raster+(0*333)+92
        defw      race_raster+(0*333)+137
IF SPECMODEL=3
        defw      race_raster+(0*333)+174
ELSE
        defw      race_raster+(0*333)+164
ENDIF
        defw      race_raster+(0*333)+204
        defw      race_raster+(0*333)+250
        defw      race_raster+(0*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/20)*(2-1)*7)+(((21-1)/19)*4)+10
        defw      race_raster+(1*333)+52
        defw      race_raster+(1*333)+92
        defw      race_raster+(1*333)+137
IF SPECMODEL=3
        defw      race_raster+(1*333)+174
ELSE
        defw      race_raster+(1*333)+164
ENDIF
        defw      race_raster+(1*333)+204
        defw      race_raster+(1*333)+250
        defw      race_raster+(1*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/20)*(2-2)*7)+(((21-2)/19)*4)+10
        defw      race_raster+(2*333)+52
        defw      race_raster+(2*333)+92
        defw      race_raster+(2*333)+137
IF SPECMODEL=3
        defw      race_raster+(2*333)+174
ELSE
        defw      race_raster+(2*333)+164
ENDIF
        defw      race_raster+(2*333)+204
        defw      race_raster+(2*333)+250
        defw      race_raster+(2*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/20)*(2-3)*7)+(((21-3)/19)*4)+10
        defw      race_raster+(3*333)+52
        defw      race_raster+(3*333)+92
        defw      race_raster+(3*333)+137
IF SPECMODEL=3
        defw      race_raster+(3*333)+174
ELSE
        defw      race_raster+(3*333)+164
ENDIF
        defw      race_raster+(3*333)+204
        defw      race_raster+(3*333)+250
        defw      race_raster+(3*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/20)*(2-4)*7)+(((21-4)/19)*4)+10
        defw      race_raster+(4*333)+52
        defw      race_raster+(4*333)+92
        defw      race_raster+(4*333)+137
IF SPECMODEL=3
        defw      race_raster+(4*333)+174
ELSE
        defw      race_raster+(4*333)+164
ENDIF
        defw      race_raster+(4*333)+204
        defw      race_raster+(4*333)+250
        defw      race_raster+(4*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/20)*(2-5)*7)+(((21-5)/19)*4)+10
        defw      race_raster+(5*333)+52
        defw      race_raster+(5*333)+92
        defw      race_raster+(5*333)+137
IF SPECMODEL=3
        defw      race_raster+(5*333)+174
ELSE
        defw      race_raster+(5*333)+164
ENDIF
        defw      race_raster+(5*333)+204
        defw      race_raster+(5*333)+250
        defw      race_raster+(5*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/20)*(2-6)*7)+(((21-6)/19)*4)+10
        defw      race_raster+(6*333)+52
        defw      race_raster+(6*333)+92
        defw      race_raster+(6*333)+137
IF SPECMODEL=3
        defw      race_raster+(6*333)+174
ELSE
        defw      race_raster+(6*333)+164
ENDIF
        defw      race_raster+(6*333)+204
        defw      race_raster+(6*333)+250
        defw      race_raster+(6*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/20)*(2-7)*7)+(((21-7)/19)*4)+10
        defw      race_raster+(7*333)+52
        defw      race_raster+(7*333)+92
        defw      race_raster+(7*333)+137
IF SPECMODEL=3
        defw      race_raster+(7*333)+174
ELSE
        defw      race_raster+(7*333)+164
ENDIF
        defw      race_raster+(7*333)+204
        defw      race_raster+(7*333)+250
        defw      race_raster+(7*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/20)*(2-8)*7)+(((21-8)/19)*4)+10
        defw      race_raster+(8*333)+52
        defw      race_raster+(8*333)+92
        defw      race_raster+(8*333)+137
IF SPECMODEL=3
        defw      race_raster+(8*333)+174
ELSE
        defw      race_raster+(8*333)+164
ENDIF
        defw      race_raster+(8*333)+204
        defw      race_raster+(8*333)+250
        defw      race_raster+(8*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/20)*(2-9)*7)+(((21-9)/19)*4)+10
        defw      race_raster+(9*333)+52
        defw      race_raster+(9*333)+92
        defw      race_raster+(9*333)+137
IF SPECMODEL=3
        defw      race_raster+(9*333)+174
ELSE
        defw      race_raster+(9*333)+164
ENDIF
        defw      race_raster+(9*333)+204
        defw      race_raster+(9*333)+250
        defw      race_raster+(9*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/20)*(2-10)*7)+(((21-10)/19)*4)+10
        defw      race_raster+(10*333)+52
        defw      race_raster+(10*333)+92
        defw      race_raster+(10*333)+137
IF SPECMODEL=3
        defw      race_raster+(10*333)+174
ELSE
        defw      race_raster+(10*333)+164
ENDIF
        defw      race_raster+(10*333)+204
        defw      race_raster+(10*333)+250
        defw      race_raster+(10*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/20)*(2-11)*7)+(((21-11)/19)*4)+10
        defw      race_raster+(11*333)+52
        defw      race_raster+(11*333)+92
        defw      race_raster+(11*333)+137
IF SPECMODEL=3
        defw      race_raster+(11*333)+174
ELSE
        defw      race_raster+(11*333)+164
ENDIF
        defw      race_raster+(11*333)+204
        defw      race_raster+(11*333)+250
        defw      race_raster+(11*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/20)*(2-12)*7)+(((21-12)/19)*4)+10
        defw      race_raster+(12*333)+52
        defw      race_raster+(12*333)+92
        defw      race_raster+(12*333)+137
IF SPECMODEL=3
        defw      race_raster+(12*333)+174
ELSE
        defw      race_raster+(12*333)+164
ENDIF
        defw      race_raster+(12*333)+204
        defw      race_raster+(12*333)+250
        defw      race_raster+(12*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/20)*(2-13)*7)+(((21-13)/19)*4)+10
        defw      race_raster+(13*333)+52
        defw      race_raster+(13*333)+92
        defw      race_raster+(13*333)+137
IF SPECMODEL=3
        defw      race_raster+(13*333)+174
ELSE
        defw      race_raster+(13*333)+164
ENDIF
        defw      race_raster+(13*333)+204
        defw      race_raster+(13*333)+250
        defw      race_raster+(13*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/20)*(2-14)*7)+(((21-14)/19)*4)+10
        defw      race_raster+(14*333)+52
        defw      race_raster+(14*333)+92
        defw      race_raster+(14*333)+137
IF SPECMODEL=3
        defw      race_raster+(14*333)+174
ELSE
        defw      race_raster+(14*333)+164
ENDIF
        defw      race_raster+(14*333)+204
        defw      race_raster+(14*333)+250
        defw      race_raster+(14*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/20)*(2-15)*7)+(((21-15)/19)*4)+10
        defw      race_raster+(15*333)+52
        defw      race_raster+(15*333)+92
        defw      race_raster+(15*333)+137
IF SPECMODEL=3
        defw      race_raster+(15*333)+174
ELSE
        defw      race_raster+(15*333)+164
ENDIF
        defw      race_raster+(15*333)+204
        defw      race_raster+(15*333)+250
        defw      race_raster+(15*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/20)*(2-16)*7)+(((21-16)/19)*4)+10
        defw      race_raster+(16*333)+52
        defw      race_raster+(16*333)+92
        defw      race_raster+(16*333)+137
IF SPECMODEL=3
        defw      race_raster+(16*333)+174
ELSE
        defw      race_raster+(16*333)+164
ENDIF
        defw      race_raster+(16*333)+204
        defw      race_raster+(16*333)+250
        defw      race_raster+(16*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/20)*(2-17)*7)+(((21-17)/19)*4)+10
        defw      race_raster+(17*333)+52
        defw      race_raster+(17*333)+92
        defw      race_raster+(17*333)+137
IF SPECMODEL=3
        defw      race_raster+(17*333)+174
ELSE
        defw      race_raster+(17*333)+164
ENDIF
        defw      race_raster+(17*333)+204
        defw      race_raster+(17*333)+250
        defw      race_raster+(17*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/20)*(2-18)*7)+(((21-18)/19)*4)+10
        defw      race_raster+(18*333)+52
        defw      race_raster+(18*333)+92
        defw      race_raster+(18*333)+137
IF SPECMODEL=3
        defw      race_raster+(18*333)+174
ELSE
        defw      race_raster+(18*333)+164
ENDIF
        defw      race_raster+(18*333)+204
        defw      race_raster+(18*333)+250
        defw      race_raster+(18*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/20)*(2-19)*7)+(((21-19)/19)*4)+10
        defw      race_raster+(19*333)+52
        defw      race_raster+(19*333)+92
        defw      race_raster+(19*333)+137
IF SPECMODEL=3
        defw      race_raster+(19*333)+174
ELSE
        defw      race_raster+(19*333)+164
ENDIF
        defw      race_raster+(19*333)+204
        defw      race_raster+(19*333)+250
        defw      race_raster+(19*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/20)*(2-20)*7)+(((21-20)/19)*4)+10
        defw      race_raster+(20*333)+52
        defw      race_raster+(20*333)+92
        defw      race_raster+(20*333)+137
IF SPECMODEL=3
        defw      race_raster+(20*333)+174
ELSE
        defw      race_raster+(20*333)+164
ENDIF
        defw      race_raster+(20*333)+204
        defw      race_raster+(20*333)+250
        defw      race_raster+(20*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/20)*(2-21)*7)+(((21-21)/19)*4)+10
        defw      race_raster+(21*333)+52
        defw      race_raster+(21*333)+92
        defw      race_raster+(21*333)+137
IF SPECMODEL=3
        defw      race_raster+(21*333)+174
ELSE
        defw      race_raster+(21*333)+164
ENDIF
        defw      race_raster+(21*333)+204
        defw      race_raster+(21*333)+250
        defw      race_raster+(21*333)+299
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 17 & 18

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/20)*(2-0)*7)+(((21-0)/19)*4)+7
        defw      race_raster+(0*333)+55
        defw      race_raster+(0*333)+95
        defw      race_raster+(0*333)+140
IF SPECMODEL=3
        defw      race_raster+(0*333)+177
ELSE
        defw      race_raster+(0*333)+175
ENDIF
        defw      race_raster+(0*333)+208
        defw      race_raster+(0*333)+253
        defw      race_raster+(0*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/20)*(2-1)*7)+(((21-1)/19)*4)+7
        defw      race_raster+(1*333)+55
        defw      race_raster+(1*333)+95
        defw      race_raster+(1*333)+140
IF SPECMODEL=3
        defw      race_raster+(1*333)+177
ELSE
        defw      race_raster+(1*333)+175
ENDIF
        defw      race_raster+(1*333)+208
        defw      race_raster+(1*333)+253
        defw      race_raster+(1*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/20)*(2-2)*7)+(((21-2)/19)*4)+7
        defw      race_raster+(2*333)+55
        defw      race_raster+(2*333)+95
        defw      race_raster+(2*333)+140
IF SPECMODEL=3
        defw      race_raster+(2*333)+177
ELSE
        defw      race_raster+(2*333)+175
ENDIF
        defw      race_raster+(2*333)+208
        defw      race_raster+(2*333)+253
        defw      race_raster+(2*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/20)*(2-3)*7)+(((21-3)/19)*4)+7
        defw      race_raster+(3*333)+55
        defw      race_raster+(3*333)+95
        defw      race_raster+(3*333)+140
IF SPECMODEL=3
        defw      race_raster+(3*333)+177
ELSE
        defw      race_raster+(3*333)+175
ENDIF
        defw      race_raster+(3*333)+208
        defw      race_raster+(3*333)+253
        defw      race_raster+(3*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/20)*(2-4)*7)+(((21-4)/19)*4)+7
        defw      race_raster+(4*333)+55
        defw      race_raster+(4*333)+95
        defw      race_raster+(4*333)+140
IF SPECMODEL=3
        defw      race_raster+(4*333)+177
ELSE
        defw      race_raster+(4*333)+175
ENDIF
        defw      race_raster+(4*333)+208
        defw      race_raster+(4*333)+253
        defw      race_raster+(4*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/20)*(2-5)*7)+(((21-5)/19)*4)+7
        defw      race_raster+(5*333)+55
        defw      race_raster+(5*333)+95
        defw      race_raster+(5*333)+140
IF SPECMODEL=3
        defw      race_raster+(5*333)+177
ELSE
        defw      race_raster+(5*333)+175
ENDIF
        defw      race_raster+(5*333)+208
        defw      race_raster+(5*333)+253
        defw      race_raster+(5*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/20)*(2-6)*7)+(((21-6)/19)*4)+7
        defw      race_raster+(6*333)+55
        defw      race_raster+(6*333)+95
        defw      race_raster+(6*333)+140
IF SPECMODEL=3
        defw      race_raster+(6*333)+177
ELSE
        defw      race_raster+(6*333)+175
ENDIF
        defw      race_raster+(6*333)+208
        defw      race_raster+(6*333)+253
        defw      race_raster+(6*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/20)*(2-7)*7)+(((21-7)/19)*4)+7
        defw      race_raster+(7*333)+55
        defw      race_raster+(7*333)+95
        defw      race_raster+(7*333)+140
IF SPECMODEL=3
        defw      race_raster+(7*333)+177
ELSE
        defw      race_raster+(7*333)+175
ENDIF
        defw      race_raster+(7*333)+208
        defw      race_raster+(7*333)+253
        defw      race_raster+(7*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/20)*(2-8)*7)+(((21-8)/19)*4)+7
        defw      race_raster+(8*333)+55
        defw      race_raster+(8*333)+95
        defw      race_raster+(8*333)+140
IF SPECMODEL=3
        defw      race_raster+(8*333)+177
ELSE
        defw      race_raster+(8*333)+175
ENDIF
        defw      race_raster+(8*333)+208
        defw      race_raster+(8*333)+253
        defw      race_raster+(8*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/20)*(2-9)*7)+(((21-9)/19)*4)+7
        defw      race_raster+(9*333)+55
        defw      race_raster+(9*333)+95
        defw      race_raster+(9*333)+140
IF SPECMODEL=3
        defw      race_raster+(9*333)+177
ELSE
        defw      race_raster+(9*333)+175
ENDIF
        defw      race_raster+(9*333)+208
        defw      race_raster+(9*333)+253
        defw      race_raster+(9*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/20)*(2-10)*7)+(((21-10)/19)*4)+7
        defw      race_raster+(10*333)+55
        defw      race_raster+(10*333)+95
        defw      race_raster+(10*333)+140
IF SPECMODEL=3
        defw      race_raster+(10*333)+177
ELSE
        defw      race_raster+(10*333)+175
ENDIF
        defw      race_raster+(10*333)+208
        defw      race_raster+(10*333)+253
        defw      race_raster+(10*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/20)*(2-11)*7)+(((21-11)/19)*4)+7
        defw      race_raster+(11*333)+55
        defw      race_raster+(11*333)+95
        defw      race_raster+(11*333)+140
IF SPECMODEL=3
        defw      race_raster+(11*333)+177
ELSE
        defw      race_raster+(11*333)+175
ENDIF
        defw      race_raster+(11*333)+208
        defw      race_raster+(11*333)+253
        defw      race_raster+(11*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/20)*(2-12)*7)+(((21-12)/19)*4)+7
        defw      race_raster+(12*333)+55
        defw      race_raster+(12*333)+95
        defw      race_raster+(12*333)+140
IF SPECMODEL=3
        defw      race_raster+(12*333)+177
ELSE
        defw      race_raster+(12*333)+175
ENDIF
        defw      race_raster+(12*333)+208
        defw      race_raster+(12*333)+253
        defw      race_raster+(12*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/20)*(2-13)*7)+(((21-13)/19)*4)+7
        defw      race_raster+(13*333)+55
        defw      race_raster+(13*333)+95
        defw      race_raster+(13*333)+140
IF SPECMODEL=3
        defw      race_raster+(13*333)+177
ELSE
        defw      race_raster+(13*333)+175
ENDIF
        defw      race_raster+(13*333)+208
        defw      race_raster+(13*333)+253
        defw      race_raster+(13*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/20)*(2-14)*7)+(((21-14)/19)*4)+7
        defw      race_raster+(14*333)+55
        defw      race_raster+(14*333)+95
        defw      race_raster+(14*333)+140
IF SPECMODEL=3
        defw      race_raster+(14*333)+177
ELSE
        defw      race_raster+(14*333)+175
ENDIF
        defw      race_raster+(14*333)+208
        defw      race_raster+(14*333)+253
        defw      race_raster+(14*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/20)*(2-15)*7)+(((21-15)/19)*4)+7
        defw      race_raster+(15*333)+55
        defw      race_raster+(15*333)+95
        defw      race_raster+(15*333)+140
IF SPECMODEL=3
        defw      race_raster+(15*333)+177
ELSE
        defw      race_raster+(15*333)+175
ENDIF
        defw      race_raster+(15*333)+208
        defw      race_raster+(15*333)+253
        defw      race_raster+(15*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/20)*(2-16)*7)+(((21-16)/19)*4)+7
        defw      race_raster+(16*333)+55
        defw      race_raster+(16*333)+95
        defw      race_raster+(16*333)+140
IF SPECMODEL=3
        defw      race_raster+(16*333)+177
ELSE
        defw      race_raster+(16*333)+175
ENDIF
        defw      race_raster+(16*333)+208
        defw      race_raster+(16*333)+253
        defw      race_raster+(16*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/20)*(2-17)*7)+(((21-17)/19)*4)+7
        defw      race_raster+(17*333)+55
        defw      race_raster+(17*333)+95
        defw      race_raster+(17*333)+140
IF SPECMODEL=3
        defw      race_raster+(17*333)+177
ELSE
        defw      race_raster+(17*333)+175
ENDIF
        defw      race_raster+(17*333)+208
        defw      race_raster+(17*333)+253
        defw      race_raster+(17*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/20)*(2-18)*7)+(((21-18)/19)*4)+7
        defw      race_raster+(18*333)+55
        defw      race_raster+(18*333)+95
        defw      race_raster+(18*333)+140
IF SPECMODEL=3
        defw      race_raster+(18*333)+177
ELSE
        defw      race_raster+(18*333)+175
ENDIF
        defw      race_raster+(18*333)+208
        defw      race_raster+(18*333)+253
        defw      race_raster+(18*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/20)*(2-19)*7)+(((21-19)/19)*4)+7
        defw      race_raster+(19*333)+55
        defw      race_raster+(19*333)+95
        defw      race_raster+(19*333)+140
IF SPECMODEL=3
        defw      race_raster+(19*333)+177
ELSE
        defw      race_raster+(19*333)+175
ENDIF
        defw      race_raster+(19*333)+208
        defw      race_raster+(19*333)+253
        defw      race_raster+(19*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/20)*(2-20)*7)+(((21-20)/19)*4)+7
        defw      race_raster+(20*333)+55
        defw      race_raster+(20*333)+95
        defw      race_raster+(20*333)+140
IF SPECMODEL=3
        defw      race_raster+(20*333)+177
ELSE
        defw      race_raster+(20*333)+175
ENDIF
        defw      race_raster+(20*333)+208
        defw      race_raster+(20*333)+253
        defw      race_raster+(20*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/20)*(2-21)*7)+(((21-21)/19)*4)+7
        defw      race_raster+(21*333)+55
        defw      race_raster+(21*333)+95
        defw      race_raster+(21*333)+140
IF SPECMODEL=3
        defw      race_raster+(21*333)+177
ELSE
        defw      race_raster+(21*333)+175
ENDIF
        defw      race_raster+(21*333)+208
        defw      race_raster+(21*333)+253
        defw      race_raster+(21*333)+322
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

; lookup table with attribute coordinates for columns 19 & 20

IF (0 < 22)
        defw      setup_raster+((22-1-0)*43)+(((21-0)/20)*(2-0)*7)+(((21-0)/19)*4)+4
        defw      race_raster+(0*333)+23
        defw      race_raster+(0*333)+98
        defw      race_raster+(0*333)+143
IF SPECMODEL=3
        defw      race_raster+(0*333)+180
ELSE
        defw      race_raster+(0*333)+178
ENDIF
        defw      race_raster+(0*333)+219
        defw      race_raster+(0*333)+275
        defw      race_raster+(0*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (1 < 22)
        defw      setup_raster+((22-1-1)*43)+(((21-1)/20)*(2-1)*7)+(((21-1)/19)*4)+4
        defw      race_raster+(1*333)+23
        defw      race_raster+(1*333)+98
        defw      race_raster+(1*333)+143
IF SPECMODEL=3
        defw      race_raster+(1*333)+180
ELSE
        defw      race_raster+(1*333)+178
ENDIF
        defw      race_raster+(1*333)+219
        defw      race_raster+(1*333)+275
        defw      race_raster+(1*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (2 < 22)
        defw      setup_raster+((22-1-2)*43)+(((21-2)/20)*(2-2)*7)+(((21-2)/19)*4)+4
        defw      race_raster+(2*333)+23
        defw      race_raster+(2*333)+98
        defw      race_raster+(2*333)+143
IF SPECMODEL=3
        defw      race_raster+(2*333)+180
ELSE
        defw      race_raster+(2*333)+178
ENDIF
        defw      race_raster+(2*333)+219
        defw      race_raster+(2*333)+275
        defw      race_raster+(2*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (3 < 22)
        defw      setup_raster+((22-1-3)*43)+(((21-3)/20)*(2-3)*7)+(((21-3)/19)*4)+4
        defw      race_raster+(3*333)+23
        defw      race_raster+(3*333)+98
        defw      race_raster+(3*333)+143
IF SPECMODEL=3
        defw      race_raster+(3*333)+180
ELSE
        defw      race_raster+(3*333)+178
ENDIF
        defw      race_raster+(3*333)+219
        defw      race_raster+(3*333)+275
        defw      race_raster+(3*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (4 < 22)
        defw      setup_raster+((22-1-4)*43)+(((21-4)/20)*(2-4)*7)+(((21-4)/19)*4)+4
        defw      race_raster+(4*333)+23
        defw      race_raster+(4*333)+98
        defw      race_raster+(4*333)+143
IF SPECMODEL=3
        defw      race_raster+(4*333)+180
ELSE
        defw      race_raster+(4*333)+178
ENDIF
        defw      race_raster+(4*333)+219
        defw      race_raster+(4*333)+275
        defw      race_raster+(4*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (5 < 22)
        defw      setup_raster+((22-1-5)*43)+(((21-5)/20)*(2-5)*7)+(((21-5)/19)*4)+4
        defw      race_raster+(5*333)+23
        defw      race_raster+(5*333)+98
        defw      race_raster+(5*333)+143
IF SPECMODEL=3
        defw      race_raster+(5*333)+180
ELSE
        defw      race_raster+(5*333)+178
ENDIF
        defw      race_raster+(5*333)+219
        defw      race_raster+(5*333)+275
        defw      race_raster+(5*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (6 < 22)
        defw      setup_raster+((22-1-6)*43)+(((21-6)/20)*(2-6)*7)+(((21-6)/19)*4)+4
        defw      race_raster+(6*333)+23
        defw      race_raster+(6*333)+98
        defw      race_raster+(6*333)+143
IF SPECMODEL=3
        defw      race_raster+(6*333)+180
ELSE
        defw      race_raster+(6*333)+178
ENDIF
        defw      race_raster+(6*333)+219
        defw      race_raster+(6*333)+275
        defw      race_raster+(6*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (7 < 22)
        defw      setup_raster+((22-1-7)*43)+(((21-7)/20)*(2-7)*7)+(((21-7)/19)*4)+4
        defw      race_raster+(7*333)+23
        defw      race_raster+(7*333)+98
        defw      race_raster+(7*333)+143
IF SPECMODEL=3
        defw      race_raster+(7*333)+180
ELSE
        defw      race_raster+(7*333)+178
ENDIF
        defw      race_raster+(7*333)+219
        defw      race_raster+(7*333)+275
        defw      race_raster+(7*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (8 < 22)
        defw      setup_raster+((22-1-8)*43)+(((21-8)/20)*(2-8)*7)+(((21-8)/19)*4)+4
        defw      race_raster+(8*333)+23
        defw      race_raster+(8*333)+98
        defw      race_raster+(8*333)+143
IF SPECMODEL=3
        defw      race_raster+(8*333)+180
ELSE
        defw      race_raster+(8*333)+178
ENDIF
        defw      race_raster+(8*333)+219
        defw      race_raster+(8*333)+275
        defw      race_raster+(8*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (9 < 22)
        defw      setup_raster+((22-1-9)*43)+(((21-9)/20)*(2-9)*7)+(((21-9)/19)*4)+4
        defw      race_raster+(9*333)+23
        defw      race_raster+(9*333)+98
        defw      race_raster+(9*333)+143
IF SPECMODEL=3
        defw      race_raster+(9*333)+180
ELSE
        defw      race_raster+(9*333)+178
ENDIF
        defw      race_raster+(9*333)+219
        defw      race_raster+(9*333)+275
        defw      race_raster+(9*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (10 < 22)
        defw      setup_raster+((22-1-10)*43)+(((21-10)/20)*(2-10)*7)+(((21-10)/19)*4)+4
        defw      race_raster+(10*333)+23
        defw      race_raster+(10*333)+98
        defw      race_raster+(10*333)+143
IF SPECMODEL=3
        defw      race_raster+(10*333)+180
ELSE
        defw      race_raster+(10*333)+178
ENDIF
        defw      race_raster+(10*333)+219
        defw      race_raster+(10*333)+275
        defw      race_raster+(10*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (11 < 22)
        defw      setup_raster+((22-1-11)*43)+(((21-11)/20)*(2-11)*7)+(((21-11)/19)*4)+4
        defw      race_raster+(11*333)+23
        defw      race_raster+(11*333)+98
        defw      race_raster+(11*333)+143
IF SPECMODEL=3
        defw      race_raster+(11*333)+180
ELSE
        defw      race_raster+(11*333)+178
ENDIF
        defw      race_raster+(11*333)+219
        defw      race_raster+(11*333)+275
        defw      race_raster+(11*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (12 < 22)
        defw      setup_raster+((22-1-12)*43)+(((21-12)/20)*(2-12)*7)+(((21-12)/19)*4)+4
        defw      race_raster+(12*333)+23
        defw      race_raster+(12*333)+98
        defw      race_raster+(12*333)+143
IF SPECMODEL=3
        defw      race_raster+(12*333)+180
ELSE
        defw      race_raster+(12*333)+178
ENDIF
        defw      race_raster+(12*333)+219
        defw      race_raster+(12*333)+275
        defw      race_raster+(12*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (13 < 22)
        defw      setup_raster+((22-1-13)*43)+(((21-13)/20)*(2-13)*7)+(((21-13)/19)*4)+4
        defw      race_raster+(13*333)+23
        defw      race_raster+(13*333)+98
        defw      race_raster+(13*333)+143
IF SPECMODEL=3
        defw      race_raster+(13*333)+180
ELSE
        defw      race_raster+(13*333)+178
ENDIF
        defw      race_raster+(13*333)+219
        defw      race_raster+(13*333)+275
        defw      race_raster+(13*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (14 < 22)
        defw      setup_raster+((22-1-14)*43)+(((21-14)/20)*(2-14)*7)+(((21-14)/19)*4)+4
        defw      race_raster+(14*333)+23
        defw      race_raster+(14*333)+98
        defw      race_raster+(14*333)+143
IF SPECMODEL=3
        defw      race_raster+(14*333)+180
ELSE
        defw      race_raster+(14*333)+178
ENDIF
        defw      race_raster+(14*333)+219
        defw      race_raster+(14*333)+275
        defw      race_raster+(14*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (15 < 22)
        defw      setup_raster+((22-1-15)*43)+(((21-15)/20)*(2-15)*7)+(((21-15)/19)*4)+4
        defw      race_raster+(15*333)+23
        defw      race_raster+(15*333)+98
        defw      race_raster+(15*333)+143
IF SPECMODEL=3
        defw      race_raster+(15*333)+180
ELSE
        defw      race_raster+(15*333)+178
ENDIF
        defw      race_raster+(15*333)+219
        defw      race_raster+(15*333)+275
        defw      race_raster+(15*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (16 < 22)
        defw      setup_raster+((22-1-16)*43)+(((21-16)/20)*(2-16)*7)+(((21-16)/19)*4)+4
        defw      race_raster+(16*333)+23
        defw      race_raster+(16*333)+98
        defw      race_raster+(16*333)+143
IF SPECMODEL=3
        defw      race_raster+(16*333)+180
ELSE
        defw      race_raster+(16*333)+178
ENDIF
        defw      race_raster+(16*333)+219
        defw      race_raster+(16*333)+275
        defw      race_raster+(16*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (17 < 22)
        defw      setup_raster+((22-1-17)*43)+(((21-17)/20)*(2-17)*7)+(((21-17)/19)*4)+4
        defw      race_raster+(17*333)+23
        defw      race_raster+(17*333)+98
        defw      race_raster+(17*333)+143
IF SPECMODEL=3
        defw      race_raster+(17*333)+180
ELSE
        defw      race_raster+(17*333)+178
ENDIF
        defw      race_raster+(17*333)+219
        defw      race_raster+(17*333)+275
        defw      race_raster+(17*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (18 < 22)
        defw      setup_raster+((22-1-18)*43)+(((21-18)/20)*(2-18)*7)+(((21-18)/19)*4)+4
        defw      race_raster+(18*333)+23
        defw      race_raster+(18*333)+98
        defw      race_raster+(18*333)+143
IF SPECMODEL=3
        defw      race_raster+(18*333)+180
ELSE
        defw      race_raster+(18*333)+178
ENDIF
        defw      race_raster+(18*333)+219
        defw      race_raster+(18*333)+275
        defw      race_raster+(18*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (19 < 22)
        defw      setup_raster+((22-1-19)*43)+(((21-19)/20)*(2-19)*7)+(((21-19)/19)*4)+4
        defw      race_raster+(19*333)+23
        defw      race_raster+(19*333)+98
        defw      race_raster+(19*333)+143
IF SPECMODEL=3
        defw      race_raster+(19*333)+180
ELSE
        defw      race_raster+(19*333)+178
ENDIF
        defw      race_raster+(19*333)+219
        defw      race_raster+(19*333)+275
        defw      race_raster+(19*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (20 < 22)
        defw      setup_raster+((22-1-20)*43)+(((21-20)/20)*(2-20)*7)+(((21-20)/19)*4)+4
        defw      race_raster+(20*333)+23
        defw      race_raster+(20*333)+98
        defw      race_raster+(20*333)+143
IF SPECMODEL=3
        defw      race_raster+(20*333)+180
ELSE
        defw      race_raster+(20*333)+178
ENDIF
        defw      race_raster+(20*333)+219
        defw      race_raster+(20*333)+275
        defw      race_raster+(20*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF

IF (21 < 22)
        defw      setup_raster+((22-1-21)*43)+(((21-21)/20)*(2-21)*7)+(((21-21)/19)*4)+4
        defw      race_raster+(21*333)+23
        defw      race_raster+(21*333)+98
        defw      race_raster+(21*333)+143
IF SPECMODEL=3
        defw      race_raster+(21*333)+180
ELSE
        defw      race_raster+(21*333)+178
ENDIF
        defw      race_raster+(21*333)+219
        defw      race_raster+(21*333)+275
        defw      race_raster+(21*333)+328
ELSE

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

ENDIF


        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0

        defw      0


; -----------------------------------------------------------------------------

PUBLIC _BIFROST2_ISR_HOOK

main_engine:
; preserve all registers
        push    af
        push    bc
        push    de
        push    hl
        ex      af, af
        exx
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy

; draw and animate next 5 tiles
        call    show_next2
        call    show_next2
        call    show_next_tile

; initial delay to synchronize with raster beam
IF 22<22
        ld      c, 22-22
skip_loop:
        ld      b, 15
        djnz    ASMPC
        ld      a, (bc)
        dec     c
        jr      nz, skip_loop
ENDIF

; preserve stack pointer
        ld      (exit_raster+1), sp

; copy in advance first line of attributes for each row
        ld      a, 8
setup_raster:

IF (0>=(22-22))
        ld      sp, $5822+((21-0)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 0>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 0>17
; additional delay to synchronize with raster beam
IF 0=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 0=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (1>=(22-22))
        ld      sp, $5822+((21-1)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 1>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 1>17
; additional delay to synchronize with raster beam
IF 1=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 1=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (2>=(22-22))
        ld      sp, $5822+((21-2)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 2>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 2>17
; additional delay to synchronize with raster beam
IF 2=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 2=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (3>=(22-22))
        ld      sp, $5822+((21-3)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 3>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 3>17
; additional delay to synchronize with raster beam
IF 3=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 3=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (4>=(22-22))
        ld      sp, $5822+((21-4)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 4>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 4>17
; additional delay to synchronize with raster beam
IF 4=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 4=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (5>=(22-22))
        ld      sp, $5822+((21-5)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 5>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 5>17
; additional delay to synchronize with raster beam
IF 5=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 5=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (6>=(22-22))
        ld      sp, $5822+((21-6)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 6>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 6>17
; additional delay to synchronize with raster beam
IF 6=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 6=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (7>=(22-22))
        ld      sp, $5822+((21-7)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 7>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 7>17
; additional delay to synchronize with raster beam
IF 7=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 7=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (8>=(22-22))
        ld      sp, $5822+((21-8)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 8>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 8>17
; additional delay to synchronize with raster beam
IF 8=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 8=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (9>=(22-22))
        ld      sp, $5822+((21-9)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 9>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 9>17
; additional delay to synchronize with raster beam
IF 9=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 9=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (10>=(22-22))
        ld      sp, $5822+((21-10)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 10>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 10>17
; additional delay to synchronize with raster beam
IF 10=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 10=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (11>=(22-22))
        ld      sp, $5822+((21-11)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 11>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 11>17
; additional delay to synchronize with raster beam
IF 11=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 11=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (12>=(22-22))
        ld      sp, $5822+((21-12)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 12>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 12>17
; additional delay to synchronize with raster beam
IF 12=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 12=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (13>=(22-22))
        ld      sp, $5822+((21-13)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 13>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 13>17
; additional delay to synchronize with raster beam
IF 13=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 13=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (14>=(22-22))
        ld      sp, $5822+((21-14)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 14>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 14>17
; additional delay to synchronize with raster beam
IF 14=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 14=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (15>=(22-22))
        ld      sp, $5822+((21-15)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 15>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 15>17
; additional delay to synchronize with raster beam
IF 15=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 15=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (16>=(22-22))
        ld      sp, $5822+((21-16)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 16>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 16>17
; additional delay to synchronize with raster beam
IF 16=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 16=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (17>=(22-22))
        ld      sp, $5822+((21-17)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 17>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 17>17
; additional delay to synchronize with raster beam
IF 17=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 17=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (18>=(22-22))
        ld      sp, $5822+((21-18)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 18>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 18>17
; additional delay to synchronize with raster beam
IF 18=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 18=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (19>=(22-22))
        ld      sp, $5822+((21-19)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 19>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 19>17
; additional delay to synchronize with raster beam
IF 19=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 19=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (20>=(22-22))
        ld      sp, $5822+((21-20)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 20>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 20>17
; additional delay to synchronize with raster beam
IF 20=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 20=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

IF (21>=(22-22))
        ld      sp, $5822+((21-21)*32)+19  ; reference columns 19 and 20
        ld      hl, 0                           ; columns 19 and 20 (1)
        ld      de, 0                           ; columns 17 and 18 (1)
        ld      bc, 0                           ; columns 15 and 16 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 13 and 14 (1)
        push    bc
        ld      bc, 0                           ; columns 11 and 12 (1)
        push    bc

IF 21>18
; additional delay to synchronize with raster beam
        ld      b, a
        djnz    ASMPC
ENDIF

        ld      hl, 0                           ; columns 9 and 10 (1)
        ld      de, 0                           ; columns 7 and 8 (1)
        ld      bc, 0                           ; columns 5 and 6 (1)
        push    hl
        push    de
        push    bc
        ld      bc, 0                           ; columns 3 and 4 (1)
        push    bc
        ld      bc, 0                           ; columns 1 and 2 (1)
        push    bc
ENDIF

IF 21>17
; additional delay to synchronize with raster beam
IF 21=18
IF SPECMODEL=3
        ld      b, 36
ELSE
        ld      b, 32
ENDIF
        djnz    ASMPC
ELSE
IF 21=21
IF SPECMODEL=3
        ld      b, a
        inc     b
ELSE
        ld      b, 9                            ; 9 if ZX-Spectrum 48K, 10 if ZX-Spectrum 128K
ENDIF
        djnz    ASMPC
ELSE
        ld      b, a
        djnz    ASMPC
        add     hl, hl
ENDIF
ENDIF
ENDIF

; race the raster beam to update attributes at the right time
race_raster:

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(0*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(0*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(0*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(0*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(0*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(0*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(0*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(0*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(0*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(0*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(0*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(0*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(0*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(1*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(1*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(1*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(1*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(1*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(1*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(1*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(1*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(1*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(1*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(1*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(1*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(1*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(2*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(2*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(2*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(2*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(2*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(2*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(2*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(2*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(2*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(2*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(2*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(2*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(2*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(3*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(3*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(3*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(3*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(3*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(3*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(3*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(3*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(3*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(3*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(3*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(3*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(3*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(4*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(4*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(4*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(4*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(4*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(4*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(4*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(4*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(4*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(4*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(4*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(4*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(4*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(5*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(5*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(5*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(5*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(5*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(5*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(5*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(5*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(5*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(5*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(5*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(5*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(5*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(6*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(6*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(6*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(6*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(6*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(6*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(6*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(6*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(6*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(6*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(6*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(6*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(6*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(7*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(7*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(7*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(7*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(7*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(7*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(7*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(7*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(7*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(7*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(7*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(7*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(7*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(8*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(8*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(8*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(8*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(8*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(8*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(8*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(8*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(8*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(8*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(8*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(8*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(8*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(9*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(9*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(9*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(9*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(9*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(9*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(9*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(9*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(9*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(9*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(9*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(9*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(9*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(10*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(10*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(10*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(10*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(10*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(10*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(10*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(10*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(10*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(10*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(10*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(10*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(10*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(11*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(11*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(11*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(11*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(11*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(11*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(11*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(11*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(11*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(11*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(11*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(11*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(11*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(12*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(12*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(12*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(12*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(12*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(12*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(12*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(12*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(12*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(12*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(12*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(12*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(12*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(13*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(13*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(13*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(13*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(13*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(13*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(13*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(13*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(13*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(13*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(13*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(13*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(13*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(14*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(14*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(14*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(14*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(14*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(14*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(14*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(14*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(14*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(14*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(14*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(14*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(14*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(15*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(15*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(15*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(15*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(15*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(15*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(15*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(15*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(15*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(15*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(15*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(15*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(15*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(16*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(16*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(16*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(16*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(16*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(16*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(16*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(16*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(16*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(16*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(16*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(16*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(16*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(17*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(17*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(17*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(17*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(17*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(17*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(17*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(17*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(17*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(17*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(17*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(17*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(17*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(18*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(18*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(18*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(18*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(18*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(18*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(18*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(18*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(18*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(18*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(18*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(18*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(18*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(19*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(19*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(19*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(19*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(19*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(19*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(19*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(19*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(19*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(19*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(19*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(19*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(19*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(20*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(20*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(20*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(20*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(20*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(20*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(20*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(20*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(20*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(20*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(20*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(20*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(20*32)+19), hl     ; columns 19 and 20

        ; --- prepare "push af/af" for later
        ld      sp, extra_buffer+(21*4)    ; reference af/af values
        pop     af                              ; columns 9 and 10 (6)
        ex      af, af
        pop     af                              ; columns 7 and 8 (4)

        ; --- set attributes for 2nd raster scan ---
        ld      sp, $5822+(21*32)+5        ; reference columns 5 and 6
        ld      hl, 0                           ; columns 9 and 10 (3)          #010
        ld      de, 0                           ; columns 11 and 12 (3)         #013
        ld      bc, 0                           ; columns 13 and 14 (3)         #016
        exx
        ld      hl, 0                           ; columns 13 and 14 (2)         #020
        ld      de, 0                           ; columns 19 and 20 (2)         #023
        ld      bc, 0                           ; columns 3 and 4 (2)           #026
        ld      ix, 0                           ; columns 1 and 2 (2)           #030
        ld      iy, 0                           ; columns 5 and 6 (2)           #034
        ld      ($5820+(21*32)+1), ix      ; columns 1 and 2
        push    iy                              ; columns 5 and 6
        push    bc                              ; columns 3 and 4
        ld      sp, $5822+(21*32)+19       ; reference columns 19 and 20
        ld      ix, 0                           ; columns 3 and 4 (7)           #048
        push    de                              ; columns 19 and 20
        ld      de, 0                           ; columns 15 and 16 (2)         #052
        ld      bc, 0                           ; columns 17 and 18 (2)         #055
        push    bc                              ; columns 17 and 18
        push    de                              ; columns 15 and 16
        push    hl                              ; columns 13 and 14
        ld      hl, 0                           ; columns 7 and 8 (2)           #061
        ld      de, 0                           ; columns 9 and 10 (2)          #064
        ld      bc, 0                           ; columns 11 and 12 (2)         #067
        push    bc                              ; columns 11 and 12
        push    de                              ; columns 9 and 10
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 3rd raster scan ---
        ld      hl, 0                           ; columns 1 and 2 (3)           #073
        ld      de, 0                           ; columns 3 and 4 (3)           #076
        ld      bc, 0                           ; columns 5 and 6 (3)           #079
IF SPECMODEL=3
        ld      iy, 0                           ; columns 5 and 6 (5)           #083 (*)
ENDIF
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
IF SPECMODEL=3
ELSE
        ld      iy, 0                           ; columns 1 and 2 (5)           #086 (*)
ENDIF
        ld      sp, $5822+(21*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (3)         #092
        ld      de, 0                           ; columns 17 and 18 (3)         #095
        ld      bc, 0                           ; columns 19 and 20 (3)         #098
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (3)           #108
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 4th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (4)          #112
        ld      de, 0                           ; columns 11 and 12 (4)         #115
        ld      bc, 0                           ; columns 13 and 14 (4)         #118
        exx
        ld      hl, 0                           ; columns 1 and 2 (4)           #122
        ld      de, 0                           ; columns 3 and 4 (4)           #125
        ld      bc, 0                           ; columns 5 and 6 (4)           #128
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        push    hl                              ; columns 1 and 2
        ld      sp, $5822+(21*32)+19       ; reference columns 19 and 20
        ld      hl, 0                           ; columns 15 and 16 (4)         #137
        ld      de, 0                           ; columns 17 and 18 (4)         #140
        ld      bc, 0                           ; columns 19 and 20 (4)         #143
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        push    af                              ; columns 7 and 8

        ; --- set attributes for 5th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (5)          #154
        ld      de, 0                           ; columns 11 and 12 (5)         #157
        ld      bc, 0                           ; columns 13 and 14 (5)         #160
        exx
IF SPECMODEL=3
        ld      hl, 0                           ; columns 1 and 2 (5)           #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        push    iy                              ; (*) columns 5 and 6
        push    de                              ; (*) columns 3 and 4
        push    hl                              ; (*) columns 1 and 2
        ld      hl, 0                           ; (*) columns 15 and 16 (5)     #174 (*)
        ld      de, 0                           ; (*) columns 17 and 18 (5)     #177 (*)
        ld      bc, 0                           ; (*) columns 19 and 20 (5)     #180 (*)
ELSE
        ld      hl, 0                           ; columns 15 and 16 (5)         #164 (*)
        ld      de, 0                           ; columns 3 and 4 (5)           #167 (*)
        ld      bc, 0                           ; columns 5 and 6 (5)           #170 (*)
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 17 and 18 (5)         #175 (*)
        ld      bc, 0                           ; columns 19 and 20 (5)         #178 (*)
        push    iy                              ; columns 1 and 2
ENDIF
        ld      sp, $5822+(21*32)+19       ; reference columns 19 and 20
        push    bc                              ; columns 19 and 20
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (5)           #193
        ex      af, af
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 6th raster scan ---
        ld      hl, 0                           ; columns 11 and 12 (6)         #198
        ld      de, 0                           ; columns 13 and 14 (6)         #201
        ld      bc, 0                           ; columns 15 and 16 (6)         #204
        exx
        ld      hl, 0                           ; columns 17 and 18 (6)         #208
        ld      de, 0                           ; columns 3 and 4 (6)           #211
        ld      bc, 0                           ; columns 5 and 6 (6)           #214
        push    bc                              ; columns 5 and 6
        push    de                              ; columns 3 and 4
        ld      de, 0                           ; columns 19 and 20 (6)         #219
        ld      bc, 0                           ; columns 1 and 2 (6)           #222
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(21*32)+19       ; reference columns 19 and 20
        push    de                              ; columns 19 and 20
        push    hl                              ; columns 17 and 18
        exx
        push    bc                              ; columns 15 and 16
        push    de                              ; columns 13 and 14
        push    hl                              ; columns 11 and 12
        push    af                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (6)           #236
        push    hl                              ; columns 7 and 8

        ; --- set attributes for 7th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (7)          #240
        ld      de, 0                           ; columns 11 and 12 (7)         #243
        ld      bc, 0                           ; columns 13 and 14 (7)         #246
        exx
        ld      hl, 0                           ; columns 15 and 16 (7)         #250
        ld      de, 0                           ; columns 17 and 18 (7)         #253
        ld      bc, 0                           ; columns 5 and 6 (7)           #256
        push    bc                              ; columns 5 and 6
        ld      bc, 0                           ; columns 1 and 2 (7)           #260
        push    ix                              ; columns 3 and 4
        push    bc                              ; columns 1 and 2
        ld      sp, $5822+(21*32)+17       ; reference columns 17 and 18
        push    de                              ; columns 17 and 18
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 19 and 20 (7)         #275
        ld      de, 0                           ; columns 7 and 8 (7)           #278
        push    de                              ; columns 7 and 8
        ld      de, 0                           ; columns 11 and 12 (8)         #282
        ld      bc, 0                           ; columns 13 and 14 (8)         #285
        ld      ($5820+(21*32)+19), hl     ; columns 19 and 20

        ; --- set attributes for 8th raster scan ---
        ld      hl, 0                           ; columns 9 and 10 (8)          #291
        exx
        ld      hl, 0                           ; columns 5 and 6 (8)           #295
        push    hl                              ; columns 5 and 6
        ld      hl, 0                           ; columns 15 and 16 (8)         #299
        ld      de, 0                           ; columns 1 and 2 (8)           #302
        ld      bc, 0                           ; columns 3 and 4 (8)           #305
        push    bc                              ; columns 3 and 4
        push    de                              ; columns 1 and 2
        ld      sp, $5822+(21*32)+15       ; reference columns 15 and 16
        push    hl                              ; columns 15 and 16
        exx
        push    bc                              ; columns 13 and 14
        push    de                              ; columns 11 and 12
        push    hl                              ; columns 9 and 10
        ld      hl, 0                           ; columns 7 and 8 (8)           #318
        push    hl                              ; columns 7 and 8
        ld      hl, 0                           ; columns 17 and 18 (8)         #322
        ld      ($5820+(21*32)+17), hl     ; columns 17 and 18
        ld      hl, 0                           ; columns 19 and 20 (8)         #328
        ld      ($5820+(21*32)+19), hl     ; columns 19 and 20

exit_raster:
; restore stack pointer
        ld      sp, 0

; available entry-point for additional interrupt routines
_BIFROST2_ISR_HOOK:
        ld      hl, 0

; restore all registers
        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af
        exx
        ex      af, af
        pop     hl
        pop     de
        pop     bc
        pop     af
        ei
		  reti

; -----------------------------------------------------------------------------
        defs 64829 - 51625 - ASMPC
; -----------------------------------------------------------------------------
; Instantly fill the tile attributes at specified position with specified value
;
; Parameters:
;   C: attribute value (0-255)
;   D: lin (0-207)
;   E: col (0-20)
;
; Destroys:
;   AF, DE, HL, AF'
;
; Address:
;   64829
; -----------------------------------------------------------------------------

PUBLIC asm_BIFROST2_fillTileAttrH

asm_BIFROST2_fillTileAttrH:
fill_tile_attr:
        ld      (exit_fill+1), sp

        srl     e                               ; E = INT(col/2)
        ld      a, e
        ex      af, af
        inc     e                               ; E = INT(col/2)+1
        xor     a
        ld      l, a                            ; L = 0
        ld      a, e                            ; AL = 256*INT(col/2)+256
        rra
        rr      l                               ; AL = 128*INT(col/2)+128
        add     a, e                            ; AL = 384*INT(col/2)+384
        ld      h, a                            ; HL = 384*INT(col/2)+384

        ld      e, d                            ; E = lin
        ld      d, lookup/512                   ; DE = lookup/2+lin
        add     hl, de                          ; HL = 384*INT(col/2)+384+lookup/2+lin
        add     hl, de                          ; HL = 384*INT(col/2)+384+lookup+2*lin
        ld      sp, hl

        ex      af, af
        jr      nc, fill_even_col

; replace attrib with value

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c
        inc     hl
        ld      (hl), c

exit_fill:
        ld      sp, 0
        ret

fill_even_col:
        cp      10
        ld      hl, -384
        jr      z, fill_last_col

; fill right side of tile

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        pop     hl
        ld      (hl), c

        and     a
        jr      z, exit_fill

        ld      hl, -(384+32)
fill_last_col:
        add     hl, sp
        ld      sp, hl

; fill left side of tile

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        pop     hl
        inc     hl
        ld      (hl), c

        jp      exit_fill

; -----------------------------------------------------------------------------
; Interrupt address at $fdfd
; -----------------------------------------------------------------------------
        jp      main_engine

; -----------------------------------------------------------------------------
; Jump vector table at addresses $fe00-$ff00
; -----------------------------------------------------------------------------
IFNDEF STRIP_VECTOR
        defs 257, 0xfd
ELSE
        defb    $fd
ENDIF

; -----------------------------------------------------------------------------
