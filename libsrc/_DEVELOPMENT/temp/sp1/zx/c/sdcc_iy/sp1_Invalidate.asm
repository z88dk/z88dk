; void __FASTCALL__ sp1_Invalidate(struct sp1_Rect *r)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_Invalidate

EXTERN _sp1_Invalidate_fastcall

_sp1_Invalidate:

   pop af
   pop hl
   
   push hl
   push af

   jp _sp1_Invalidate_fastcall
