; void sms_tiles_clear_area(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_clear_area_callee

EXTERN _sms_cls_wc_callee

defc _sms_tiles_clear_area_callee = _sms_cls_wc_callee
