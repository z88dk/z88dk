; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_scroll_wc_up_callee

EXTERN asm_sms_scroll_wc_up

_sms_scroll_wc_up_callee:

   pop hl
   pop ix
   dec sp
   pop de
   ex (sp),hl
   
   ld e,d
   jp asm_sms_scroll_wc_up
