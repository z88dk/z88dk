
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_LIST_INIT

; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_list_clear(p_list_t *list)
;
; Clear list to empty.
;
; ===============================================================

asm_p_list_clear:

   ; enter : hl = p_list_t *
   ;
   ; exit  : de = p_list_t *
   ;
   ; uses  : af, de, hl
