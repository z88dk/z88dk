; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateRect

EXTERN asm0_sp1_IterateUpdateRect

sp1_IterateUpdateRect:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm0_sp1_IterateUpdateRect
