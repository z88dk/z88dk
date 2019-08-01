
; ===============================================================
; Nov 2013
; ===============================================================
; 
; int abs(int j)
;
; Return absolute value of j.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_abs

EXTERN l_neg_hl

asm_abs:

   ; enter : hl = int j
   ;
   ; exit  : hl = abs(j)
   ;
   ; uses  : af, hl, carry unaffected (not 808x)
IF __CPU_INTEL__
   ld a,h
   rla
   ret nc
ELSE 
   bit 7,h
   ret z
ENDIF

   jp l_neg_hl
