
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)
;
; Clear list to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_clear

EXTERN asm_p_forward_list_alt_init

defc asm_p_forward_list_alt_clear = asm_p_forward_list_alt_init

   ; enter : hl = p_forward_list_alt_t *
   ;
   ; exit  : de = p_forward_list_alt_t *
   ;
   ; uses  : af, de, hl
