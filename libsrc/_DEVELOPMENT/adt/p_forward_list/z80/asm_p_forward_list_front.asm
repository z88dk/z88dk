
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_front(p_forward_list_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

PUBLIC asm_p_forward_list_front

EXTERN error_einval_zc

   inc hl
   inc hl

asm_p_forward_list_front:

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   ret nz
   
   jp error_einval_zc
