
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_ALT_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_alt_clear(forward_list_alt *list)
;
; Clear list to empty.
;
; ===============================================================

asm_forward_list_alt_clear:

   ; enter : hl = forward_list_alt *
   ;
   ; exit  : de = forward_list_alt *
   ;
   ; uses  : af, de, hl
