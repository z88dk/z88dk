; void sp1_Initialize(uchar iflag, uchar colour, uchar tile)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_Initialize_callee

EXTERN asm_sp1_Initialize

_sp1_Initialize_callee:

   pop bc
   pop hl
   ld a,l
   pop de
   pop hl
   ld h,e
   push bc
   
   jp asm_sp1_Initialize
