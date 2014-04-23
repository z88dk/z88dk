; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)
; CALLER linkage for function pointers

XLIB sp1_IterateUpdateArr

LIB asm_sp1_IterateUpdateArr

sp1_IterateUpdateArr:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm_sp1_IterateUpdateArr
