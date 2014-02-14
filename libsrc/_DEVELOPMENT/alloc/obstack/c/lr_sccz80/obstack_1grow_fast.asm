
; void *obstack_1grow_fast(struct obstack *ob, char c)

XLIB obstack_1grow_fast

LIB asm_obstack_1grow_fast

obstack_1grow_fast:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,e
   jp asm_obstack_1grow_fast
