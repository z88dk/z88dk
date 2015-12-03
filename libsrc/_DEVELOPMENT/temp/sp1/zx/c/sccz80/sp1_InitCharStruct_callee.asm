; void __CALLEE__ sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_InitCharStruct_callee

EXTERN asm_sp1_InitCharStruct

sp1_InitCharStruct_callee:

   pop hl
   pop bc
   ld a,c
   ex af,af
   pop bc
   pop de
   ld a,e
   pop de
   ex (sp),hl

   jp asm_sp1_InitCharStruct
