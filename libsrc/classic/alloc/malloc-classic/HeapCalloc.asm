; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapCalloc
PUBLIC _HeapCalloc

EXTERN asm_HeapCalloc

.HeapCalloc
._HeapCalloc

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   inc sp
   inc sp
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   dec sp
   dec sp
   ELSE
   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   push af
   ENDIF
   
   jp asm_HeapCalloc
