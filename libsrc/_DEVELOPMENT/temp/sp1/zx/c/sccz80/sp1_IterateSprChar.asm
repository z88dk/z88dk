; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)
; CALLER linkage for function pointers

SECTION seg_code_sp1

PUBLIC sp1_IterateSprChar

EXTERN asm_sp1_IterateSprChar

sp1_IterateSprChar:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm_sp1_IterateSprChar
