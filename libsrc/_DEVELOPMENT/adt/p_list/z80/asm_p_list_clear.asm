
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_list_clear(p_list_t *list)
;
; Clear list to empty.
;
; ===============================================================

PUBLIC asm_p_list_clear

EXTERN asm_p_list_init

asm_p_list_clear:

   jp asm_p_list_init

;defc asm_p_list_clear = asm_p_list_init

   ; enter : hl = p_list_t *
   ;
   ; exit  : de = p_list_t *
   ;
   ; uses  : af, de, hl
