; void sms_tiles_get_area(struct r_Rect8 *r, void *dst)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_get_area_callee

EXTERN asm_sms_tiles_get_area

_sms_tiles_get_area_callee:

   pop af
   pop ix
   pop de
   push af
   
   jp asm_sms_tiles_get_area
