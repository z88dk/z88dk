
; ===============================================================
; Jul 2015
; ===============================================================
; 
; void _lldiv_(lldiv_t *ld, int64_t numer, int64_t denom)
;
; Fill the lldiv_t struct with the results of long long divide
; numer / denom.
;
; struct lldiv_t
; {
;    int64_t rem;
;    int64_t quot;
; };
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__lldiv

EXTERN l_divs_64_64x64, __lldiv_store

asm__lldiv:

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
   ;              | -2   lldiv_t *ld
   ;              +------------------------
   ;
   ; exit  : lldiv_t.quot = numer / denom
   ;         lldiv_t.rem  = numer % denom
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call l_divs_64_64x64
   
   ; dehl'dehl = remainder
   ; stack.numer = quotient
   
   jp __lldiv_store
