; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cls_wc_callee

EXTERN asm_sms_cls_wc

_sms_cls_wc_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   jp asm_sms_cls_wc
