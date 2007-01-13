; CALLER LINKAGE FOR FUNCTION POINTERS

XLIB vz_brick
LIB vz_brick_callee
XREF ASMDISP_VZ_BRICK_CALLEE

.vz_brick

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp vz_brick_callee + ASMDISP_VZ_BRICK_CALLEE
