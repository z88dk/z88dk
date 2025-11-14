; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_scroll_wc_up_callee
PUBLIC _sms_scroll_wc_up_callee_0

EXTERN asm_sms_scroll_wc_up

_sms_scroll_wc_up_callee:

   pop hl
   pop bc
   dec sp
   pop de
   ex (sp),hl

_sms_scroll_wc_up_callee_0:

   push bc
   ex (sp),ix

   ld e,d
   call asm_sms_scroll_wc_up
   
   pop ix
   ret
