; void sms_tiles_get_area(struct r_Rect8 *r, void *dst)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_tiles_get_area_callee
PUBLIC _sms_tiles_get_area_callee_0

EXTERN asm_sms_tiles_get_area

_sms_tiles_get_area_callee:

   pop af
   pop bc
   pop de
   push af
   
_sms_tiles_get_area_callee_0:

   push bc
   ex (sp),ix
   
   call asm_sms_tiles_get_area
   
   pop ix
   ret
