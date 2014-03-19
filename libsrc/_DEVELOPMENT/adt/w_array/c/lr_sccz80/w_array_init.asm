
; w_array_t *w_array_init(void *p, void *data, size_t capacity)

XLIB w_array_init

LIB asm_w_array_init

w_array_init:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_w_array_init
