; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC sms_cls_wc_callee

EXTERN asm_sms_cls_wc

sms_cls_wc_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_sms_cls_wc
