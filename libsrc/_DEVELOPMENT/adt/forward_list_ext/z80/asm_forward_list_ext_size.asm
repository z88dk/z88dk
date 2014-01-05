*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_SIZE()

; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t forward_list_ext_size(forward_list_ext *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

asm_forward_list_ext_size:

   ; enter : hl = forward_list_ext *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl

