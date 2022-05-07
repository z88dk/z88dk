
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

defc SP1V_PIXELBUFFER   = $bcf8            ; address of an 8-byte buffer to hold intermediate pixel-draw results

; ///////////////////////
;     Temp Variables
; ///////////////////////

defc SP1V_TEMP_AF       = $bcf2
defc SP1V_TEMP_IX       = $bcf6
defc SP1V_TEMP_IY       = $bced

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

defc SP1V_UPDATELISTH   = $bcef            ; address of 9-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $bcf0            ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn

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
; bd00 - d4ff     ZX81HRG  256x192 display file (suggested, least significant 5 bits of address must be 0)
; bcf8 - bcff     SP1.LIB  pixel buffer
; bcef - bcf7     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * bcf0 - bcf1  SP1.LIB  update list tail pointer (inside dummy struct sp1_update)
;  * bcf2 - bcf3  SP1.LIB  SP1V_TEMP_AF (inside dummy struct sp1_update)
;  * bcf6 - bcf7  SP1.LIB  SP1V_TEMP_IX (inside dummy struct sp1_update)
; bced - bcee     SP1.LIB  SP1V_TEMP_IY
