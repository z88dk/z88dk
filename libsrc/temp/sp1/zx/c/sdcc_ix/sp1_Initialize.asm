; void sp1_Initialize(uchar iflag, uchar colour, uchar tile)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_Initialize

EXTERN asm_sp1_Initialize

_sp1_Initialize:

   ld hl,2
   add hl,sp
   
   ld a,(hl)
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   ex de,hl

   jp asm_sp1_Initialize
