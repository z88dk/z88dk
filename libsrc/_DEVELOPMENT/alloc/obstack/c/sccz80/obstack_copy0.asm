
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)

SECTION seg_code_obstack

PUBLIC obstack_copy0

EXTERN asm_obstack_copy0

obstack_copy0:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_obstack_copy0
