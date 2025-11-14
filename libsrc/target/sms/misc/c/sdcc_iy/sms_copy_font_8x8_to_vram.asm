; void *sms_copy_font_8x8_to_vram(void *font, unsigned char num, unsigned char cbgnd, unsigned char cfgnd)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_copy_font_8x8_to_vram

EXTERN asm_sms_copy_font_8x8_to_vram

_sms_copy_font_8x8_to_vram:

   pop af
   pop hl
   dec sp
   pop bc
   pop de
   
   push de
   push bc
   inc sp
   push hl
   push af

   ld c,b
   jp asm_sms_copy_font_8x8_to_vram
