; void ulap_write_color(unsigned char pent,unsigned char color)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_write_color_callee

EXTERN asm_ulap_write_color

_ulap_write_color_callee:

   pop hl
   ex (sp),hl

   jp asm_ulap_write_color
