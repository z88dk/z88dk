
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_clear(forward_list *list)
;
; Clear list to empty.
;
; ===============================================================

asm_forward_list_clear:

   ; enter : hl = forward_list *
   ;
   ; exit  : de = forward_list *
   ;
   ; uses  : af, de, hl
