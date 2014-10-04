
; void *obstack_init(struct obstack *ob, size_t size)

SECTION seg_code_obstack

PUBLIC obstack_init

EXTERN asm_obstack_init

obstack_init:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_obstack_init
