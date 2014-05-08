
; int obstack_grow0(struct obstack *ob, void *data, size_t size)

PUBLIC obstack_grow0

EXTERN asm_obstack_grow0

obstack_grow0:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_obstack_grow0
