
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_ALT_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)
;
; Clear list to empty.
;
; ===============================================================

asm_p_forward_list_alt_clear:

   ; enter : hl = p_forward_list_alt_t *
   ;
   ; exit  : de = p_forward_list_alt_t *
   ;
   ; uses  : af, de, hl
