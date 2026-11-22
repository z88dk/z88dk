; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InitCharStruct_callee

EXTERN asm_sp1_InitCharStruct

_sp1_InitCharStruct_callee:

   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   ld a,c
   pop bc
   exx
   pop de
   ex af,af'
   ld a,e
   ex af,af'
   push bc
   exx
   
   jp asm_sp1_InitCharStruct
