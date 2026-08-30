
; void *obstack_int_grow(struct obstack *ob, int data)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_int_grow

EXTERN asm_obstack_int_grow

obstack_int_grow:

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
   
   jp asm_obstack_int_grow

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_int_grow
defc _obstack_int_grow = obstack_int_grow
ENDIF

