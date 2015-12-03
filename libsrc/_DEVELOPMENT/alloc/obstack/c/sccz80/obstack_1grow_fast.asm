
; void *obstack_1grow_fast(struct obstack *ob, char c)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_1grow_fast

EXTERN l0_obstack_1grow_fast_callee

obstack_1grow_fast:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_obstack_1grow_fast_callee
