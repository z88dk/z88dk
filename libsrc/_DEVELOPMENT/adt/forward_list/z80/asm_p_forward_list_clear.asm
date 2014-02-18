
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_clear(p_forward_list_t *list)
;
; Clear list to empty.
;
; ===============================================================

asm_p_forward_list_clear:

   ; enter : hl = p_forward_list_t *
   ;
   ; exit  : de = p_forward_list_t *
   ;
   ; uses  : af, de, hl
