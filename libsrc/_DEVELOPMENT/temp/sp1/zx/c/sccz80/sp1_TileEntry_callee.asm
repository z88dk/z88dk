; void __CALLEE__ *sp1_TileEntry_callee(uchar c, void *def)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_TileEntry_callee

EXTERN asm_sp1_TileEntry

sp1_TileEntry_callee:

   pop hl
   pop de
   pop bc
   push hl

   jp asm_sp1_TileEntry
