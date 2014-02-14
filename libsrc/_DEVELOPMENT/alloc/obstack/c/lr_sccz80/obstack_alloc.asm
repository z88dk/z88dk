
; void *obstack_alloc(struct obstack *ob, size_t size)

XLIB obstack_alloc

LIB asm_obstack_alloc

obstack_alloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_alloc
