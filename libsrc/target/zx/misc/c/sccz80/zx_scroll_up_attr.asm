; void zx_scroll_up_attr(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up_attr

EXTERN asm0_zx_scroll_up_attr

zx_scroll_up_attr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm0_zx_scroll_up_attr
