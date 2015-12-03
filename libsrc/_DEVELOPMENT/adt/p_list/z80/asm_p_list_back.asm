
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_back(p_list_t *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_back

EXTERN asm_p_forward_list_front

asm_p_list_back:

   inc hl
   inc hl

   jp asm_p_forward_list_front

   ; enter : hl = p_list_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at back)
   ;            nz flag set
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
