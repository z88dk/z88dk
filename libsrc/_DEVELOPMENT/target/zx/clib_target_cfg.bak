
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
defc __model        = 0                ; 0 = 48k
defc __clock_freq   = 3500000          ; Hz

defc __z80_cpu_info = $01

; bit 0 = $01 = if set indicates an nmos z80 (if unsure set it)
; bit 1 = $02 = allow undocumented instruction "sll r"


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
