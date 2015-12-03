; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateSpr

EXTERN asm_sp1_IterateUpdateSpr

sp1_IterateUpdateSpr:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm_sp1_IterateUpdateSpr
