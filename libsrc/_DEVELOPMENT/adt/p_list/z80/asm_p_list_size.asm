
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t p_list_size(p_list_t *list)
;
; Return number of items in list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_size

EXTERN asm_p_forward_list_size

defc asm_p_list_size = asm_p_forward_list_size

   ; enter : hl = p_list_t *list
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
