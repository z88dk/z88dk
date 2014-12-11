
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void _div(div_t *d, int numer, int denom)
;
; Fill the div_t struct with the results of integer divide
; numer / denom.
;
; struct div_t
; {
;    int rem;
;    int quot;
; };
;
; ===============================================================

SECTION code_stdlib

PUBLIC asm__div

EXTERN l_divs_16_16x16

asm__div:

   ; enter : bc = div_t *
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
   
   push bc                     ; save div_t *
   
   call l_divs_16_16x16        ; hl = hl/de, de = hl%de
   
   ex (sp),hl                  ; hl = div_t *
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop bc                      ; bc = hl/de
   
   ld (hl),c
   inc hl
   ld (hl),b
   
   ld l,c
   ld h,b
   ret
