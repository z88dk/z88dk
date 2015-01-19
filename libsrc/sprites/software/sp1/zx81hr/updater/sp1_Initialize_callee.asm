; void __CALLEE__ sp1_Initialize_callee(uchar iflag, uchar tile)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

INCLUDE "zx81hr/customize.asm"

PUBLIC sp1_Initialize_callee
PUBLIC ASMDISP_SP1_INITIALIZE_CALLEE
EXTERN base_graphics

EXTERN zx81toasc

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
PUBLIC SP1V_TEMP_IX
PUBLIC SP1V_TEMP_IY
PUBLIC SP1V_TEMP_AF

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
; used  : af, bc, de, hl

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

   ; Initialize tile array to point to characters in ROM
   
   ; The problem here is that the zx81 character set is not
   ; in ascii sequence and the bitmaps stored in ROM are in
   ; the zx81 character set sequence.  So here we step through
   ; all 64 bitmap definitions, convert the associated zx81
   ; code (0-63) to an ascii code and then store the bitmap
   ; address for that ascii code into the tile map.
   ;
   ; The zx81 does not contain bitmap definitions for lower
   ; case letters so in the second phase we copy the bitmaps
   ; for the upper case letters into the lower case tile maps.
   ; This way, initially, all alpha chars both upper and lower
   ; case will at least display as upper case letters.
   
   ; a = flag
   
   ld c,a
   ld b,64
   ld d,SP1V_TILEARRAY/256
   ld hl,$1e00                      ; zx81 rom char bitmaps

.tileloop

   ld a,64
   sub b
   cp 11
   jr c, codeok                     ; if it's a block graphic, leave in 0-10
   call zx81toasc+1                 ; convert zx81 code in A to ascii


.codeok
   
   ld e,a                           ; de = tile array entry for ascii code
   ex de,hl                         ; hl = tile array entry, de = zx81 rom bitmap
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
   
   ld a,8
   add a,e
   ld e,a
   ld a,0
   adc a,d
   ld d,a

   ex de,hl
   djnz tileloop

   ; now copy upper case tiles to lower case tiles
   
   ld de,SP1V_TILEARRAY + 'A'       ; tile entry for 'A'
   ld hl,SP1V_TILEARRAY + 'a'       ; tile entry for 'a'
   ld b,26                          ; 26 letters in the english alphabet

.tileloop2

   ld a,(hl)                        ; if a tile address is already present (ie non-zero entry)
   inc h                            ;   then we will skip it
   bit 1,c
   jr nz, overwrite2                ; unless overwrite flag set
   or (hl)
   jr nz, tilepresent2

.overwrite2

   inc d
   ld a,(de)
   ld (hl),a
   dec h
   dec d
   ld a,(de)
   ld (hl),a
   inc h
   
.tilepresent2

   dec h

   inc hl
   inc de
   djnz tileloop2

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
   push af
   
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

   pop af
   jr z, skipscrnaddr
   push af
   
   ld a,(base_graphics)             ; compute screen address for char coord (b,c)
   add a,c
   ld (hl),a
   inc hl
   ld a,(base_graphics + 1)
   adc a,b
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

   pop af
   ret

.skipscrnaddr

   push af
   inc hl
   jp rejoinscrnaddr

DEFC ASMDISP_SP1_INITIALIZE_CALLEE = # asmentry - sp1_Initialize_callee
