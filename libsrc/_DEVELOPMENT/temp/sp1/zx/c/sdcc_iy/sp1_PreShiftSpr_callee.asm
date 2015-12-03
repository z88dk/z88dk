; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PreShiftSpr_callee, l0_sp1_PreShiftSpr_callee

EXTERN asm_sp1_PreShiftSpr

_sp1_PreShiftSpr_callee:

   exx
   pop bc
   exx
   
   pop hl
   ld h,l
   pop bc
   ld l,c
   pop bc
   ld a,c
   pop de
   pop ix
   pop bc
   ld b,a
   ld a,c
   
   exx
   push bc
   exx

l0_sp1_PreShiftSpr_callee:

   push ix
   ex (sp),iy

   call asm_sp1_PreShiftSpr

   pop iy
   ret
