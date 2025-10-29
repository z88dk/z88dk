
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_list_front(p_list_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_front

EXTERN asm_p_forward_list_front

defc asm_p_list_front = asm_p_forward_list_front

   ; enter : hl = p_list_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            nz flag set
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
