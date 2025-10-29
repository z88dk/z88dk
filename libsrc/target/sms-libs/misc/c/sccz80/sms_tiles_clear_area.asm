; void sms_tiles_clear_area(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC sms_tiles_clear_area

EXTERN sms_cls_wc

defc sms_tiles_clear_area = sms_cls_wc
