
; CUSTOMIZATION TEMPLATE FOR SP1
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res-graphics version

; This customization file is intended for a 64k
; zx96 computer with memory map as follows:
;
; 0000 - 1fff :  8k : ROM
; 2000 - 3fff :  8k : RAM or EPROM/EEPROM (m/c possible)
; 4000 - 7fff : 16k : RAM (basic, m/c possible)
; 8000 - bfff : 16k : RAM (basic, m/c possible)
; c000 - ffff : 16k : RAM/RAM-echo (only data, no m/c)
;
; For other targets you must select a different
; and appropriate memory map by making changes below.
; At least 32k RAM is recommended.
;
; Keep in mind that the "struct sp1_ss" and "struct sp1_cs"
; that the library allocates when creating sprites contain
; executable code, meaning they must be allocated out of a
; memory block capable of executing m/c.

; ///////////////////////
; Display Characteristics
; ///////////////////////

defc SP1V_DISPORIGX     = 0                ; x coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPORIGY     = 0                ; y coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPWIDTH     = 32               ; width of area managed by sp1 in characters (16, 24, 32 ok as of now)
defc SP1V_DISPHEIGHT    = 24               ; height of area managed by sp1 in characters (anything reasonable ok)

; ///////////////////////
;        Buffers
; ///////////////////////

defc SP1V_PIXELBUFFER   = $d4f8            ; address of an 8-byte buffer to hold intermediate pixel-draw results

; ///////////////////////
;     Temp Variables
; ///////////////////////

defc SP1V_TEMP_AF       = $d4f2
defc SP1V_TEMP_IX       = $d4f6
defc SP1V_TEMP_IY       = $d4ed

; ///////////////////////
;     Data Structures
; ///////////////////////

defc SP1V_TILEARRAY     = $f000            ; address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
defc SP1V_UPDATEARRAY   = $d500            ; address of the 9*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
defc SP1V_ROTTBL        = $f000            ; location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                           ;  pointer ($f200-$ffff in this default case).  Set to $0000 if the table is not needed (if, for example, all sprites
                                           ;  are drawn at exact horizontal character coordinates or you use pre-shifted sprites only).
; ///////////////////////
;      SP1 Variables
; ///////////////////////

defc SP1V_UPDATELISTH   = $d4ef            ; address of 9-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $d4f0            ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

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
; d500 - efff     SP1.LIB  update array for 32x24 display
; d4f8 - d4ff     SP1.LIB  pixel buffer
; d4ef - d4f7     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * d4f0 - d4f1  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
;  * d4f2 - d4f3  SP1.LIB  SP1V_TEMP_AF (inside dummy struct sp1_update)
;  * d4f6 - d4f7  SP1.LIB  SP1V_TEMP_IX (inside dummy struct sp1_update)
; d4ed - d4ee     SP1.LIB  SP1V_TEMP_IY
; bc6d - d4ec     ZX81HRG  base graphics -- 6144 + 128 byte 256x192 display file (suggested)
