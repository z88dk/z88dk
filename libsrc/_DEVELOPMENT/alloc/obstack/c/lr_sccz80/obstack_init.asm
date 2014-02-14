
; void *obstack_init(struct obstack *ob, size_t size)

XLIB obstack_init

LIB asm_obstack_init

obstack_init:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_obstack_init
