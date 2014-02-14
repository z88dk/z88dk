
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)

XLIB obstack_align_distance

LIB asm_obstack_align_distance

obstack_align_distance:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_align_distance
