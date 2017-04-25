; void sms_tiles_put_area(struct r_Rect8 *r, void *src)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_put_area

EXTERN _sms_tiles_put_area_callee_0

_sms_tiles_put_area:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp _sms_tiles_put_area_callee_0
