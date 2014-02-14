
; int obstack_align_to(struct obstack *ob, size_t alignment)

XLIB obstack_align_to

LIB asm_obstack_align_to

obstack_align_to:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_align_to
