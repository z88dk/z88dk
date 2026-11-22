
; void *obstack_init(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_init

EXTERN asm_obstack_init

obstack_init:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   ELSE
   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   ENDIF
   
   jp asm_obstack_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_init
defc _obstack_init = obstack_init
ENDIF

