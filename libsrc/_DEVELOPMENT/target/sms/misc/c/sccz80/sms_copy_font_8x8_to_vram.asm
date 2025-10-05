; void *sms_copy_font_8x8_to_vram(void *font, unsigned char num, unsigned char cbgnd, unsigned char cfgnd)

SECTION code_clib
SECTION code_arch

PUBLIC sms_copy_font_8x8_to_vram

EXTERN asm_sms_copy_font_8x8_to_vram

sms_copy_font_8x8_to_vram:

   pop af
   pop bc
   pop de
   ld d,c
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push bc
   push af

   jp asm_sms_copy_font_8x8_to_vram
