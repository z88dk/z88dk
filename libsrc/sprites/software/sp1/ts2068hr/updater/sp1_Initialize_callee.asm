; void __CALLEE__ sp1_Initialize_callee(uchar iflag, uchar tile)
; 02.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

INCLUDE "ts2068hr/customize.asm"

PUBLIC sp1_Initialize_callee
PUBLIC ASMDISP_SP1_INITIALIZE_CALLEE

PUBLIC SP1V_DISPORIGX
PUBLIC SP1V_DISPORIGY
PUBLIC SP1V_DISPWIDTH
PUBLIC SP1V_DISPHEIGHT
PUBLIC SP1V_PIXELBUFFER
PUBLIC SP1V_TILEARRAY
PUBLIC SP1V_UPDATEARRAY
PUBLIC SP1V_ROTTBL
PUBLIC SP1V_UPDATELISTH
PUBLIC SP1V_UPDATELISTT

.sp1_Initialize_callee

   pop bc
   pop hl
   pop de
   ld a,e
   push bc
   
.asmentry

; 1. Constructs the rotation table if SP1_IFLAG_MAKE_ROTTBL flag set
; 2. Initializes tile array so that ROM character set is used by
;    default - if SP1_IFLAG_OVERWRITE_TILES flag is set will not alter
;    graphic pointers for character codes set previously (any non-zero
;    pointer is not touched)
; 3. Resets the invalidated list to empty
; 4. Resets the update array, generating display file addresses for
;    each char square if SP1_IFLAG_OVERWRITE_DFILE flag is set
;
; enter :  hl= startup background tile
;          a = flag, bit 0 = 1 if rotation table needed, bit 1 = 1 to overwrite all tile defs
;              bit 2 = 1 to overwrite screen addresses in update structs
; used  : af, bc, de, hl, af'

.SP1Initialize

   push hl                         ; save tile

   bit 0,a
   jr z, norottbl                  ; if flag bit not set, do not construct rotation table

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
   bit 1,c
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
   ld hl,0
   ld (SP1V_UPDATELISTH+5),hl       ; nothing in invalidate list

   ; initialize the update array

   pop de                           ; de = tile code
   ld b,SP1V_DISPORIGY              ; b = current row coord
   ld hl,SP1V_UPDATEARRAY           ; hl = current struct sp1_update
   bit 2,c
   ex af,af
   
.rowloop

   ld c,SP1V_DISPORIGX              ; c = current col coord
   
.colloop

   ld (hl),1                        ; # of occluding sprites in this tile + 1
   inc hl
   ld (hl),e                        ; write tile code
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0                        ; no sprites in the tile
   inc hl
   ld (hl),0
   inc hl
   ld (hl),0                        ; not in invalidated list
   inc hl

   ex af,af
   jr z, skipscrnaddr
   ex af,af
   
   ld a,b                           ; compute screen address for char coord (b,c)
   rrca                             ; and store in struct sp1_update
   rrca
   rrca
   and $e0                          ; screen address : 010B BSSS LLLC CCCC
   ld d,a
   ld a,c
   rra
   or d                             ; y coord (b)    : 000B BLLL
   ld (hl),a                        ; x coord (c)    : 000C CCCC
   inc hl
   ld a,b
   and $18
   or $40
   bit 0,c
   jr z, evencol
   or $20
.evencol
   ld (hl),a

.rejoinscrnaddr

   inc hl                           ; hl points at next struct sp1_update
   inc c                            ; next column
   ld a,c
   cp SP1V_DISPORIGX + SP1V_DISPWIDTH
   jr c, colloop
   
   inc b                            ; next row
   ld a,b
   cp SP1V_DISPORIGY + SP1V_DISPHEIGHT
   jr c, rowloop

   ret

.skipscrnaddr

   ex af,af
   inc hl
   jp rejoinscrnaddr

DEFC ASMDISP_SP1_INITIALIZE_CALLEE = # asmentry - sp1_Initialize_callee
