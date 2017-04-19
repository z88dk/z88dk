; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cls_wc

EXTERN asm_sms_cls_wc

_sms_cls_wc:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_sms_cls_wc
