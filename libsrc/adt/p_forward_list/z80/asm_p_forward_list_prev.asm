
; ===============================================================
; Sep 2014
; ===============================================================
; 
; void *p_forward_list_prev(forward_list_t *list, void *item)
;
; Return previous item in list.  O(n)
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_prev

EXTERN __p_forward_list_locate_item, error_zc

asm_p_forward_list_prev:

   ; enter : hl = forward_list_t *
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
   ; uses  : af, de, hl

   call __p_forward_list_locate_item
   jp c, error_zc
   
   ex de,hl                    ; de = void *item_prev
   
   sbc hl,de
   jp z, error_zc              ; if item was last in list
   
   ex de,hl                    ; hl = void *item_prev
   
   or a
   ret
