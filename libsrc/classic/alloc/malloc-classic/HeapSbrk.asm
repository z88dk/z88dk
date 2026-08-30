; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapSbrk
PUBLIC _HeapSbrk

EXTERN asm_HeapSbrk

.HeapSbrk
._HeapSbrk

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   inc sp
   inc sp
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   dec sp
   dec sp
   ELSE
   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   ENDIF
   
   jp asm_HeapSbrk
