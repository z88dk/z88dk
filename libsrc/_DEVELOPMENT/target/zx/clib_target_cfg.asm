
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
;-- GAMES/BIFROST_L -------------------------------------------
;--------------------------------------------------------------

; Animation speed: 2 or 4 frames per second
defc __BIFROSTL_ANIM_SPEED = 4

; Animation size: 2 or 4 frames per animation group
defc __BIFROSTL_ANIM_GROUP = 4

; First non-animated frame
defc __BIFROSTL_STATIC_MIN = 128

; Value subtracted from non-animated frames
defc __BIFROSTL_STATIC_OVERLAP = 128

; Location of the tiles table (64 bytes per tile)
defc __BIFROSTL_TILE_IMAGES = 48500

; Location of the tile map (9x9=81 tiles)
defc __BIFROSTL_TILE_MAP = 65281

; Tile rendering order (1 for sequential, 7 for distributed)
defc __BIFROSTL_TILE_ORDER = 7


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
;;define(`__BIFROST2_TOTAL_ROWS', 22)


;--------------------------------------------------------------
;-- GAMES/NIRVANA- --------------------------------------------
;--------------------------------------------------------------

defc __NIRVANAM_OPTIONS = 0

; bit 0 = $01 = enable wide draw
; bit 1 = $02 = enable wide sprites

;;define(`__NIRVANAM_TOTAL_ROWS', 22)

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

;;define(`__NIRVANAP_TOTAL_ROWS', 23)

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
