
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)
;
; Clear list to empty.
;
; ===============================================================

XLIB asm_p_forward_list_alt_clear

LIB asm_p_forward_list_alt_init

defc asm_p_forward_list_alt_clear = asm_p_forward_list_alt_init

   ; enter : hl = p_forward_list_alt_t *
   ;
   ; exit  : de = p_forward_list_alt_t *
   ;
   ; uses  : af, de, hl
