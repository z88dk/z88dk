
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_back(p_forward_list_alt_t *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_back

EXTERN l_readword_hl, error_zc

asm_p_forward_list_alt_back:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (last item in list)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, hl

   ld a,(hl)
   inc hl
   or (hl)
   inc hl
   
   jp nz, l_readword_hl
   
   jp error_zc  
