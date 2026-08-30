
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_copy0

EXTERN asm_obstack_copy0

obstack_copy0:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   inc sp
   inc sp
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   dec sp
   dec sp
   ELSE
   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   ENDIF

   jp asm_obstack_copy0

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_copy0
defc _obstack_copy0 = obstack_copy0
ENDIF

