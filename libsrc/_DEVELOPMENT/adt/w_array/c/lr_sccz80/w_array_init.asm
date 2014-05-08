
; w_array_t *w_array_init(void *p, void *data, size_t capacity)

PUBLIC w_array_init

EXTERN asm_w_array_init

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
