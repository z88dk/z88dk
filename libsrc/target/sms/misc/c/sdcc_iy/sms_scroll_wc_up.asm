; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_scroll_wc_up

EXTERN asm_sms_scroll_wc_up

_sms_scroll_wc_up:

   pop af
   pop ix
   dec sp
   pop de
   pop hl
   
   push hl
   push de
   inc sp
   push hl
   push af

   ld e,d
   jp asm_sms_scroll_wc_up
