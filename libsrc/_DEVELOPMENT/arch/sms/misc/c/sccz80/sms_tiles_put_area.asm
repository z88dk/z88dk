; void sms_tiles_put_area(struct r_Rect8 *r, void *src)

SECTION code_clib
SECTION code_arch

PUBLIC sms_tiles_put_area

EXTERN asm_sms_tiles_put_area

sms_tiles_put_area:

   pop af
   pop de
   pop ix
   
   push hl
   push de
   push af
   
   jp asm_sms_tiles_put_area
