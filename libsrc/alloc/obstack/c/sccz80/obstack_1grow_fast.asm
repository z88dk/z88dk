
; void *obstack_1grow_fast(struct obstack *ob, char c)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_1grow_fast

EXTERN l0_obstack_1grow_fast_callee

obstack_1grow_fast:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   ELSE
   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   ENDIF
   
   jp l0_obstack_1grow_fast_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_1grow_fast
defc _obstack_1grow_fast = obstack_1grow_fast
ENDIF

