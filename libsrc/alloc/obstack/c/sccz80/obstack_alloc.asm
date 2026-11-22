
; void *obstack_alloc(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_alloc

EXTERN asm_obstack_alloc

obstack_alloc:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   ELSE
   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   ENDIF
   
   jp asm_obstack_alloc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_alloc
defc _obstack_alloc = obstack_alloc
ENDIF

