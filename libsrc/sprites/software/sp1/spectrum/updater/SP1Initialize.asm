
; SP1Initialize
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Initialize
XREF SP1V_IDTYPEASSOC, SP1V_SPRDRAWTBL
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT
XREF SP1V_UPDATEARRAY, SP1V_TILEARRAY
XREF SP1V_ROTTBL
XREF SP1V_DISPORIGX, SP1V_DISPORIGY
XREF SP1V_DISPWIDTH, SP1V_DISPHEIGHT

; 1. Stores locations of idtypeassoc table and sprdraw function table
; 2. Constructs the rotation table if relevant flag set
; 3. Initializes tile array so that ROM character set is used by
;    default - will not alter graphic pointers for character codes
;    set previously (any non-zero pointer is not touched)
; 4. Resets the invalidated list to empty
; 5. Resets the update array
;
; enter :  h = startup background attribute
;          l = startup background tile
;         bc = & sprdraw table (table of sprite draw char functions indexed by type)
;         de = & idtype table (table of id/type pairs that associates id with type, ends in id=0)
;          a = flag, bit 0 = 1 if rotation table needed, bit 1 = 1 to overwrite all tile defs
; used  : af, bc, de, hl

.SP1Initialize

   push hl                         ; save h = attr, l = tile

   ld (SP1V_IDTYPEASSOC),de
   ld (SP1V_SPRDRAWTBL),bc

   rra
   jr nc, norottbl                 ; if flag bit not set, do not construct rotation table

   ; construct the rotation table
  
   ld c,7                          ; rotate by c bits
   push af

.rottbllp

   ld a,c
   add a,a
   or SP1V_ROTTBL/256
   ld h,a
   ld l,0
   
.entrylp

   ld b,c
   ld e,l
   xor a

.rotlp

   srl e
   rra
   djnz rotlp

   ld (hl),e
   inc h
   ld (hl),a
   dec h
   inc l
   jp nz, entrylp

   dec c
   jp nz, rottbllp
   pop af

.norottbl

   ; initialize tile array to point to characters in ROM
   
   ld hl,SP1V_TILEARRAY
   ld de,15360
   ld b,0
   ld c,a

.tileloop

   ld a,(hl)                        ; if a tile address is already present (ie non-zero entry)
   inc h                            ;   then we will skip it
   bit 0,c
   jr nz, overwrite                 ; unless overwrite flag set
   or (hl)
   jr nz, tilepresent

.overwrite

   ld (hl),d
   dec h
   ld (hl),e
   inc h
   
.tilepresent

   dec h
   inc hl

   ld a,8
   add a,e
   ld e,a
   ld a,0
   adc a,d
   ld d,a

   djnz tileloop

   ; init the invalidated list
   
   ld hl,SP1V_UPDATELISTH           ; this variable points at a dummy struct sp1_update that is
   ld (SP1V_UPDATELISTT),hl
   ld de,SP1V_UPDATELISTH+1         ; always the first struct sp1_update in the invalidated list
   ld (hl),0
   ld bc,8                          ; sizeof(struct sp1_update) - 1
   ldir

   ; initialize the update array

   pop de                           ; d = attr, e = tile
   ld b,SP1V_ORIGY                  ; b = current row coord
   ld hl,SP1V_UPDATEARRAY           ; hl = current struct sp1_update
   
.rowloop

   ld c,SP1V_ORIGX                  ; c = current col coord
   
.colloop

   ld (hl),1                        ; # of occluding sprites in this tile + 1
   inc hl
   ld (hl),d                        ; write tile colour
   inc hl
   ld (hl),e                        ; write tile code
   inc hl
   ld (hl),0                        ; no sprites in the tile
   inc hl
   ld (hl),0
   inc hl

   ld a,b                           ; compute screen address for char coord (b,c)
   rrca                             ; and store in struct sp1_update
   rrca
   rrca
   and $e0                          ; screen address : 010B BSSS LLLC CCCC
   or c                             ; y coord (b)    : 000B BLLL
   ld (hl),a                        ; x coord (c)    : 000C CCCC
   inc hl
   ld a,b
   and $18
   or $40
   ld (hl),a

   inc hl                           ; hl points at next struct sp1_update
   inc c                            ; next column
   ld a,c
   cp SP1V_ORIGX + SP1V_DISPWIDTH
   jr c, colloop
   
   inc b                            ; next row
   ld a,b
   cp SP1V_ORIGY + SP1V_DISPHEIGHT
   jr c, rowloop

   ret
