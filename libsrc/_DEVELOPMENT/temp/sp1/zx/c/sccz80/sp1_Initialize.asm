; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_Initialize

EXTERN asm_sp1_Initialize

sp1_Initialize:

   ld hl,6
   add hl,sp
   ld a,(hl)
   dec hl
   dec hl
   ld d,(hl)
   dec hl
   dec hl
   ld e,(hl)
   ex de,hl

   jp asm_sp1_Initialize
