; void *sms_copy_font_8x8_to_vram(void *font, unsigned char num, unsigned char cbgnd, unsigned char cfgnd)

SECTION code_clib
SECTION code_arch

PUBLIC sms_copy_font_8x8_to_vram_callee

EXTERN asm_sms_copy_font_8x8_to_vram

sms_copy_font_8x8_to_vram_callee:

   pop hl
   pop bc
   pop de
   ld d,c
   pop bc
   ex (sp),hl

   jp asm_sms_copy_font_8x8_to_vram

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_copy_font_8x8_to_vram_callee
defc _sms_copy_font_8x8_to_vram_callee = sms_copy_font_8x8_to_vram_callee
ENDIF

