
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

XLIB w_array_insert

LIB asm_w_array_insert

w_array_insert:

   pop ix
   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   push ix
   
   jp asm_w_array_insert
