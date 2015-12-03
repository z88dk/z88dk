
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int atoi(const char *buf)
;
; Read the initial portion of the string as decimal integer and
; return value read.  Any initial whitespace is skipped.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_atoi, asm0_atoi

EXTERN l_eat_ws, l_eat_sign, l_neg_hl, l_atou

asm_atoi:

   ; enter : hl = char *buf
   ;
   ; exit  : de = char *buf (next unprocessed char, could be digit on overflow)
   ;         hl = int result
   ;         carry set on overflow (hl clamped to INT_MAX or INT_MIN)
   ;
   ; uses  : af, bc, de, hl

   call l_eat_ws               ; skip over any initial whitespace

asm0_atoi:

   call l_eat_sign             ; consume any leading sign
   jr nc, not_negative         ; if there was no minus sign
   
   ; negative sign found
   
   call not_negative           ; convert numerical part
   jp nc, l_neg_hl             ; if no overflow, negate result
   
   inc hl                      ; hl = $8000 = INT_MIN
   ret

not_negative:

   ex de,hl
   call l_atou                 ; unsigned int conversion
   jr c, overflow              ; unsigned overflow
   
   bit 7,h                     ; check for signed overflow
   ret z
   
   scf                         ; indicate signed overflow

overflow:

   ld hl,$7fff                 ; hl = $7fff = INT_MAX
   ret
