
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

XLIB obstack_copy

LIB asm_obstack_copy

obstack_copy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_obstack_copy
