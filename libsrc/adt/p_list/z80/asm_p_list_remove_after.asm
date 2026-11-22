
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_remove_after(p_list_t *list, void *list_item)
;
; Remove item following list_item from the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_remove_after

EXTERN asm_p_list_remove, error_zc

asm_p_list_remove_after:

   ; enter : bc = p_list_t *list
   ;         hl = void *list_item
   ;
   ; exit  : bc = p_list_t *list
   ;
   ;         success
   ;
   ;            hl = void *item (item removed)
   ;            carry reset
   ;
   ;         fail if following item does not exist
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, asm_p_list_remove

   jp error_zc
