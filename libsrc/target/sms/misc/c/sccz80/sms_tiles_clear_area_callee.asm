; void sms_tiles_clear_area(struct r_Rect8 *r, unsigned int background)

SECTION code_clib
SECTION code_arch

PUBLIC sms_tiles_clear_area_callee

EXTERN sms_cls_wc_callee

defc sms_tiles_clear_area_callee = sms_cls_wc_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_tiles_clear_area_callee
defc _sms_tiles_clear_area_callee = sms_tiles_clear_area_callee
ENDIF

