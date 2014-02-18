
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_SIZE

; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t p_list_size(p_list_t *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

asm_p_list_size:

   ; enter : hl = p_list_t *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
