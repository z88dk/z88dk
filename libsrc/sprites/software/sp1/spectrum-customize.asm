
; CUSTOMIZATION TEMPLATE FOR SP1
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

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

defc SP1V_PIXELBUFFER   = $xxxx            ; address of an 8-byte buffer to hold intermediate pixel-draw results
defc SP1V_ATTRBUFFER    = $xxxx            ; address of a single byte buffer to hold intermediate colour-draw results

; ///////////////////////
;     Data Structures
; ///////////////////////

defc SP1V_TILEARRAY     = $xx00            ; address of the 512-byte tile array associating character codes with tile graphics, must lie on 256-byte boundary (LSB=0)
defc SP1V_UPDATEARRAY   = $xxxx            ; address of the 9*SP1V_DISPWIDTH*SP1V_DISPHEIGHT byte update array
defc SP1V_ROTTBL        = $f000            ; location of the 3584-byte rotation table.  Must lie on 256-byte boundary (LSB=0).  Table begins $0200 bytes ahead of this
                                           ;  pointer ($f200-$ffff in this default case).  Can be eliminated with appropriate flag to sp1_Initialize()

; ///////////////////////
;      SP1 Variables
; ///////////////////////

defc SP1V_UPDATELISTH   = $xxxx            ; address of 9-byte area holding a dummy struct_sp1_update that is always the "first" in list of screen tiles to be drawn
defc SP1V_UPDATELISTT   = $xxxx            ; address of 2-byte variable holding the address of the last struct_sp1_update in list of screen tiles to be drawn
defc SP1V_IDTYPEASSOC   = $xxxx            ; address of 2-byte variable holding the address of a table of ID/TYPE pairs, you supply this table address to sp1_Invalidate()
defc SP1V_SPRDRAWTBL    = $xxxx            ; address of 2-byte variable holding the address of a table of sprite draw functions indexed by type, you supply this
                                           ;  table address to sp1_Invalidate()
