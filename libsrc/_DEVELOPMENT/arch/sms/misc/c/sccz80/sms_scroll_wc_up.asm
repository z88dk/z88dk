; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)

SECTION code_clib
SECTION code_arch

PUBLIC sms_scroll_wc_up

EXTERN asm_sms_scroll_wc_up

sms_scroll_wc_up:

   pop af
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push af

   jp asm_sms_scroll_wc_up
