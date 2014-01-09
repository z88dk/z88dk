
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_EMPTY

; ===============================================================
; Jan 2014
; ===============================================================
; 
; int list_empty(list *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

asm_list_empty:

   ; enter : hl = list *
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
