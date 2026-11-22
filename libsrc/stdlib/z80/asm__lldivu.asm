
; ===============================================================
; Jul 2015
; ===============================================================
; 
; void _lldivu_(lldivu_t *ld, uint64_t numer, uint64_t denom)
;
; Fill the lldivu_t struct with the results of long long divide
; numer / denom.
;
; struct lldivu_t
; {
;    uint64_t rem;
;    uint64_t quot;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__lldivu

EXTERN l_divu_64_64x64, __lldiv_store

asm__lldivu:

   ; enter :      +------------------------
   ;              | +15 
   ;              | ...  denom (8 bytes)
   ;              | +8 
   ;              |------------------------
   ;              | +7
   ;              | ...  numer (8 bytes)
   ;         ix = | +0
   ;              |------------------------
   ;              | -1
   ;              | -2   lldivu_t *ld
   ;              +------------------------
   ;
   ; exit  : lldiv_t.quot = numer / denom
   ;         lldiv_t.rem  = numer % denom
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call l_divu_64_64x64
   
   ; dehl'dehl = remainder
   ; stack.numer = quotient
   
   jp __lldiv_store
