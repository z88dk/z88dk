; void ulap_write_color(unsigned char pent,unsigned char color)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_write_color_callee

EXTERN asm_ulap_write_color

ulap_write_color_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld h,e
   jp asm_ulap_write_color
