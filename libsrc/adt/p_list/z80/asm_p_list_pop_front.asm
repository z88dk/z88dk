
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_pop_front(p_list_t *list)
;
; Pop item from the front of the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_pop_front

EXTERN asm_p_list_remove, error_zc

asm_p_list_pop_front:

   ; enter : hl = p_list_t *list
   ;
   ; exit  : bc = p_list_t *list
   ;
   ;         success
   ;
   ;            hl = void *item (item at front)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, asm_p_list_remove
   
   jp error_zc
