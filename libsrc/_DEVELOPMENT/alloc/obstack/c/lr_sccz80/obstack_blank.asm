
; void *obstack_blank(struct obstack *ob, int size)

XLIB obstack_blank

LIB asm_obstack_blank

obstack_blank:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_blank
