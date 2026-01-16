; void sms_tiles_get_area(struct r_Rect8 *r, void *dst)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_get_area

EXTERN _sms_tiles_get_area_callee_0

_sms_tiles_get_area:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp _sms_tiles_get_area_callee_0
