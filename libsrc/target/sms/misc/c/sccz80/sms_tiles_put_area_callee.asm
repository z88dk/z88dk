; void sms_tiles_put_area(struct r_Rect8 *r, void *src)

SECTION code_clib
SECTION code_arch

PUBLIC sms_tiles_put_area_callee

EXTERN asm_sms_tiles_put_area

sms_tiles_put_area_callee:

   pop af
   pop de
   pop ix
   push af
   
   jp asm_sms_tiles_put_area

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_tiles_put_area_callee
defc _sms_tiles_put_area_callee = sms_tiles_put_area_callee
ENDIF

