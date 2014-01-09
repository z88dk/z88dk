
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_SIZE

; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t list_size(list *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

asm_list_size:

   ; enter : hl = list *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
