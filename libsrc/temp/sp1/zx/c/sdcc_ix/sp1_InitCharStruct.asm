; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InitCharStruct

EXTERN asm_sp1_InitCharStruct

_sp1_InitCharStruct:

   ld hl,10
   add hl,sp
   
   ld a,(hl)
   ex af,af'
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   
   exx
   pop bc
   exx
   pop hl
   
   push hl
   exx
   push bc
   exx
   
   jp asm_sp1_InitCharStruct
