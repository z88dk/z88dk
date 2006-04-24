
; CUSTOMIZATION TEMPLATE FOR SP1
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; See below for Memory Map with these default settings

; ///////////////////////
; Display Characteristics
; ///////////////////////

defc SP1V_DISPORIGX     = 0                ; x coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPORIGY     = 0                ; y coordinate of top left corner of area managed by sp1 in characters
defc SP1V_DISPWIDTH     = 32               ; width of area managed by sp1 in characters (16, 24, 32 ok as of now)
defc SP1V_DISPHEIGHT    = 24               ; height of area managed by sp1 in characters

; ///////////////////////
;        Buffers
; ///////////////////////

defc SP1V_PIXELBUFFER   = $d4f7            ; address of an 8-byte buffer to hold intermediate pixel-draw results
defc SP1V_ATTRBUFFER    = $d4ff            ; address of a single byte buffer to hold intermediate colour-draw results

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

defc SP1V_UPDATELISTH   = $d4ee            ; address of 9-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $d4f1            ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn
defc SP1V_IDTYPEASSOC   = $d4ee            ; address of 2-byte variable holding the address of a table of ID/TYPE pairs, you supply this table address to sp1_Initialize()
defc SP1V_SPRDRAWTBL    = $d4f5            ; address of 2-byte variable holding the address of a table of sprite draw functions indexed by type, you supply this
                                           ;  table address to sp1_Initialize()

; NOTE: SP1V_UPDATELISTT, SP1V_IDTYPEASSOC, SP1V_SPRDRAWTBL are located inside unused
;       portions of the dummy struct_sp1_update pointed at by SP1V_UPDATELISTH

; ///////////////////////
;   DEFAULT MEMORY MAP
; ///////////////////////

; With these default settings the suggested memory map is:
;
; ADDRESS (HEX)   LIBRARY  DESCRIPTION
;
; f200 - ffff     SP1.LIB  horizontal rotation tables
; f000 - f1ff     SP1.LIB  tile array
; d500 - efff     SP1.LIB  update array for full size screen 32x24
; d4ff - d4ff     SP1.LIB  attribute buffer
; d4f7 - d4fe     SP1.LIB  pixel buffer
; d4ee - d4f6     SP1.LIB  update list head - a dummy struct sp1_update acting as first in invalidated list
;  * d4f1 - d4f2  SP1.LIB  update list tail pointer
;  * d4ee - d4ef  SP1.LIB  id / type association table address
;  * d4f5 - d4f6  SP1.LIB  sprite draw function table (indexed by type) address
; d4e5 - d4ed     --free-  11 bytes
; d4d4 - d4e4     IM2.LIB  generic isr with one hook
; d401 - d4d3     --free-  228 bytes
; d300 - d400     IM2.LIB  im 2 vector table
; d100 - d2ff     -------  z80 stack (512 bytes) set SP=d300
;
; * = variables located inside the struct pointed at by the update list head
