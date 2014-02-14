
; void *obstack_blank_fast(struct obstack *ob, int size)

XLIB obstack_blank_fast

LIB asm_obstack_blank_fast

obstack_blank_fast:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_blank_fast
