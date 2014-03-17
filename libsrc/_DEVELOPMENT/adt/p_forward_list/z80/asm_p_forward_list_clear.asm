
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_clear(p_forward_list_t *list)
;
; Clear list to empty.
;
; ===============================================================

XLIB asm_p_forward_list_clear

LIB l_zeroword_hl

defc asm_p_forward_list_clear = l_zeroword_hl

   ; enter : hl = p_forward_list_t *
   ;
   ; exit  : hl = p_forward_list_t *
   ;
   ; uses  : none
