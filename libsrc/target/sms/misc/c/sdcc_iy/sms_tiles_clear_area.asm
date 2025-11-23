; void sms_tiles_clear_area(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_clear_area

EXTERN _sms_cls_wc

defc _sms_tiles_clear_area = _sms_cls_wc
