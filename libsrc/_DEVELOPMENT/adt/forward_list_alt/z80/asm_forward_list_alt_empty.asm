
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_EMPTY

; ===============================================================
; Dec 2013
; ===============================================================
; 
; int forward_list_alt_empty(forward_list_alt *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

asm_forward_list_alt_empty:

   ; enter : hl = forward_list *
   ;
   ; exit  : if list is empty
   ;
   ;           hl = 1
   ;           carry set
   ;
   ;         if list is not empty
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ; uses  : af, hl
