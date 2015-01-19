; void __CALLEE__ *sp1_TileEntry_callee(uchar c, void *def)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_TileEntry_callee
PUBLIC ASMDISP_SP1_TILEENTRY_CALLEE
EXTERN SP1V_TILEARRAY

.sp1_TileEntry_callee

   pop hl
   pop de
   pop bc
   push hl

.asmentry

; Associate a new graphic with character code passed in.
;
; enter : de = address of udg graphic to associate with character code
;          c = char code
; exit  : hl = old udg graphic associated with char code
; uses  : af, b, de, hl

.SP1TileEntry

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

DEFC ASMDISP_SP1_TILEENTRY_CALLEE = # asmentry - sp1_TileEntry_callee
