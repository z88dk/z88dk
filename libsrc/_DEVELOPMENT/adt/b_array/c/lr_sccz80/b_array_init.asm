
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

XLIB b_array_init

LIB asm_b_array_init

b_array_init:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_b_array_init
