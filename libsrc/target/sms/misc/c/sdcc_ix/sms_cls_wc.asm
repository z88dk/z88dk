; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cls_wc

EXTERN _sms_cls_wc_callee_0

_sms_cls_wc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp _sms_cls_wc_callee_0
