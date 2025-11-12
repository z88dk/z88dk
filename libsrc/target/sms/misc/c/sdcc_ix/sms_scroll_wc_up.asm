; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_scroll_wc_up

EXTERN _sms_scroll_wc_up_callee_0

_sms_scroll_wc_up:

   pop af
   pop bc
   dec sp
   pop de
   pop hl
   
   push hl
   push de
   inc sp
   push bc
   push af

   jp _sms_scroll_wc_up_callee_0
