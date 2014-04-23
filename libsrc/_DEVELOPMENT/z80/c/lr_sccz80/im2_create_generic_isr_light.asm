
; void *im2_create_generic_isr_light(uint8_t num_callback, void *address)

XLIB im2_create_generic_isr_light

LIB asm_im2_create_generic_isr_light

im2_create_generic_isr_light:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,l
   jp asm_im2_create_generic_isr_light
