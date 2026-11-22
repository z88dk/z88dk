
; ===============================================================
; Jul 2015
; ===============================================================
; 
; void _ldivu(ldivu_t *ld, uint32_t numer, uint32_t denom)
;
; Fill the ldivu_t struct with the results of long divide
; numer / denom.
;
; struct ldivu_t
; {
;    uint32_t quot;
;    uint32_t rem;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__ldivu

EXTERN l_divu_32_32x32, __ldiv_store

asm__ldivu:

   ; enter :   bc  = ldivu_t * 
   ;         dehl  = denom
   ;         dehl' = numer
   ;
   ; exit  : ldiv_t.quot = numer / denom
   ;         ldiv_t.rem  = numer % denom
   ;
   ;         dehl' = numer % denom
   ;         dehl  = numer / denom
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ixh
   
   push bc                     ; save ldivu_t *
      
   call l_divu_32_32x32

   ; dehl  = numer / denom
   ; dehl' = numer % denom
   ; stack  = ldivu_t *

   jp __ldiv_store
