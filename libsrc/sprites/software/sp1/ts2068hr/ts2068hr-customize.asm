
; CUSTOMIZATION TEMPLATE FOR SP1
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

; See below for Memory Map with these default settings

; ///////////////////////
; Display Characteristics
; ///////////////////////

defc SP1V_DISPORIGX     = 8                ; x coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPORIGY     = 1                ; y coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPWIDTH     = 48               ; width of area managed by sp1 in characters (16, 24, 32, 40, 48, 56, 64 ok as of now)
defc SP1V_DISPHEIGHT    = 22               ; height of area managed by sp1 in characters

; ///////////////////////
;        Buffers
; ///////////////////////

defc SP1V_PIXELBUFFER   = $cad8            ; address of an 8-byte buffer to hold intermediate pixel-draw results

; ///////////////////////
;     Data Structures
; ///////////////////////

defc SP1V_TILEARRAY     = $f000            ; address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
defc SP1V_UPDATEARRAY   = $cae0            ; address of the 9*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
defc SP1V_ROTTBL        = $f000            ; location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                           ;  pointer ($f200-$ffff in this default case).  Set to $0000 if the table is not needed (if, for example, all sprites
                                           ;  are drawn at exact horizontal character coordinates or you use pre-shifted sprites only).
; ///////////////////////
;      SP1 Variables
; ///////////////////////

defc SP1V_UPDATELISTH   = $cacf            ; address of 9-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $cad0            ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

; NOTE: SP1V_UPDATELISTT is located inside the dummy struct_sp1_update pointed at by SP1V_UPDATELISTH

; ///////////////////////
;   DEFAULT MEMORY MAP
; ///////////////////////

; With these default settings the memory map is:
;
; ADDRESS (HEX)   LIBRARY  DESCRIPTION
;
; f200 - ffff     SP1.LIB  horizontal rotation tables
; f000 - f1ff     SP1.LIB  tile array
; cae0 - efff     SP1.LIB  update array for partial screen 48x22 (x9 bytes)
; cad8 - cadf     SP1.LIB  pixel buffer
; cacf - cad7     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * cad0 - cad1  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
; caca - cace     -------  JP to im2 service routine (im2 table filled with 0xca bytes)
; ca01 - cac9     --free-  201 bytes (alternate location for smaller z80 stack SP=caca)
; c900 - ca00     IM2.LIB  im2 vector table (257 bytes)
; c700 - c8ff     -------  z80 stack (512 bytes) set SP=c900
;
