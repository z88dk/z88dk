
; ===============================================================
; Sep 2014
; ===============================================================
; 
; void *p_list_prev(void *item)
;
; Return next item in list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_prev

EXTERN asm_p_forward_list_next

asm_p_list_prev:

   ; enter : hl = void *item
   ;
   ; exit  : success
   ;
   ;           hl = void *item_prev
   ;           nz flag set
   ;
   ;         fail if no prev item
   ;
   ;           hl = 0
   ;           z flag set
   ;
   ; uses  : af, hl

   inc hl
   inc hl
   
   call asm_p_forward_list_next
   ret z
   
   dec hl
   dec hl
   
   ret
