; void *sp1_TileEntry_callee(uchar c, void *def)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_TileEntry

asm_sp1_TileEntry:

; Associate a new graphic with character code passed in.
;
; enter : de = address of udg graphic to associate with character code
;          c = char code
; exit  : hl = old udg graphic associated with char code
; uses  : af, b, de, hl

   ld hl,SP1V_TILEARRAY
   ld b,0
   add hl,bc
   ld a,(hl)
   ld (hl),e
   ld e,a
   inc h
   ld a,(hl)
   ld (hl),d
   ld h,a
   ld l,e

   ret
