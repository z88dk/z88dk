
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_init(void *p)
;
; Create an empty forward_list_ext in the four bytes of memory
; provided.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_init

EXTERN asm_p_forward_list_init

asm_p_forward_list_alt_init:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = p_forward_list_alt_t *list
   ;
   ; uses  : af, de, hl
   
   call asm_p_forward_list_init
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; p_forward_list_alt->tail = & p_forward_list_alt->head
   inc hl
   
   ret
