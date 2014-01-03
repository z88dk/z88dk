
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t forward_list_ext_size(forward_list_ext *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_ext_size

LIB asm_forward_list_size

asm_forward_list_ext_size:

   ; enter : hl = forward_list_ext *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
   
   jp asm_forward_list_size
