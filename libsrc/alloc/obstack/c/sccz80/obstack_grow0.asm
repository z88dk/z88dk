
; int obstack_grow0(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_grow0

EXTERN asm_obstack_grow0

obstack_grow0:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_obstack_grow0

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_grow0
defc _obstack_grow0 = obstack_grow0
ENDIF

