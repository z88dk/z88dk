
; ===============================================================
; Dec 2013
; ===============================================================
; 
; long atol(const char *buf)
;
; Read the initial portion of the string as decimal long and
; return value read.  Any initial whitespace is skipped.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_atol

EXTERN l_eat_ws, l_eat_sign, l_neg_dehl, l_atoul

asm_atol:

   ; enter : hl = char *buf
   ;
   ; exit  : bc = char *buf (next unprocessed char, could be digit on overflow)
   ;         dehl = long result
   ;         carry set on overflow (dehl clamped to LONG_MAX or LONG_MIN)
   ;
   ; uses  : af, bc, de, hl

   call l_eat_ws               ; skip over any initial whitespace
   call l_eat_sign             ; consume any leading sign
   jr nc, not_negative         ; if there was no minus sign
   
   ; negative sign found
   
   call not_negative           ; convert numerical part
   jp nc, l_neg_dehl           ; if no overflow, negate result
      
   inc de
   inc hl                      ; dehl = LONG_MIN = $80000000
   ret

not_negative:

   ex de,hl
   call l_atoul                ; unsigned long conversion
   jr c, overflow              ; unsigned overflow
   
   bit 7,d                     ; check for signed overflow
   ret z
   
   scf                         ; indicate signed overflow

overflow:

   ld de,$7fff
   ld h,e
   ld l,e                      ; dehl = LONG_MAX = $7fffffff
   ret
