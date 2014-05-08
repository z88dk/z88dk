
; void *im2_create_generic_isr(uint8_t num_callback, void *address)

PUBLIC im2_create_generic_isr

EXTERN asm_im2_create_generic_isr

im2_create_generic_isr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,l
   jp asm_im2_create_generic_isr
