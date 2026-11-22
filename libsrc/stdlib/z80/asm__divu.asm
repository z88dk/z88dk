
; ===============================================================
; Jul 2015
; ===============================================================
; 
; void _divu(divu_t *d, uint16_t numer, uint16_t denom)
;
; Fill the divu_t struct with the results of integer divide
; numer / denom.
;
; struct divu_t
; {
;    uint16_t rem;
;    uint16_t quot;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__divu

EXTERN l_divu_16_16x16, __div_store

asm__divu:

   ; enter : bc = divu_t *
   ;         de = denom
   ;         hl = numer
   ;
   ; exit  : div_t.rem  = numer % denom = hl % de
   ;         div_t.quot = numer / denom = hl / de
   ;
   ;         bc = hl / de
   ;         hl = hl / de
   ;         de = hl % de
   ;
   ; uses  : af, bc, de, hl
   
   push bc                     ; save divu_t *
   
   call l_divu_16_16x16        ; hl = hl/de, de = hl%de
   
   jp __div_store
