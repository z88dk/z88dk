
; ===============================================================
; Sep 2014
; ===============================================================
; 
; void *p_forward_list_alt_prev(forward_list_alt_t *list, void *item)
;
; Return previous item in list.  O(n)
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_prev

EXTERN asm_p_forward_list_prev

defc asm_p_forward_list_alt_prev = asm_p_forward_list_prev

   ; enter : hl = forward_list_alt_t *
   ;         bc = void *item
   ;
   ; exit  : success
   ;
   ;           hl = void *item_prev
   ;           carry reset
   ;
   ;         fail if no previous item
   ;
   ;           hl = 0
   ;           carry set
   ;
   ; uses  : af, hl
