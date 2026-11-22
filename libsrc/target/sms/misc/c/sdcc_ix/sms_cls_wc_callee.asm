; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cls_wc_callee
PUBLIC _sms_cls_wc_callee_0

EXTERN asm_sms_cls_wc

_sms_cls_wc_callee:

   pop hl
   pop bc
   ex (sp),hl

_sms_cls_wc_callee_0:

   push bc
   ex (sp),ix
   
   call asm_sms_cls_wc
   
   pop ix
   ret
