
; void *obstack_1grow_fast(struct obstack *ob, char c)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_1grow_fast

EXTERN l0_obstack_1grow_fast_callee

_obstack_1grow_fast:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_obstack_1grow_fast_callee
