
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_list_clear(p_list_t *list)
;
; Clear list to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_clear

EXTERN asm_p_list_init

defc asm_p_list_clear = asm_p_list_init

   ; enter : hl = p_list_t *
   ;
   ; exit  : de = p_list_t *
   ;
   ; uses  : af, de, hl
