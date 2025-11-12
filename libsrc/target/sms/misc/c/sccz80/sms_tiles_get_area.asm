; void sms_tiles_get_area(struct r_Rect8 *r, void *dst)

SECTION code_clib
SECTION code_arch

PUBLIC sms_tiles_get_area

EXTERN asm_sms_tiles_get_area

sms_tiles_get_area:

   pop af
   pop de
   pop ix
   
   push hl
   push de
   push af
   
   jp asm_sms_tiles_get_area

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_tiles_get_area
defc _sms_tiles_get_area = sms_tiles_get_area
ENDIF

