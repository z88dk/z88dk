; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)
; CALLER linkage for function pointers

SECTION seg_code_sp1

PUBLIC sp1_IterateUpdateArr

EXTERN asm_sp1_IterateUpdateArr

sp1_IterateUpdateArr:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm_sp1_IterateUpdateArr
