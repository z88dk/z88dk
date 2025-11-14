
; ===============================================================
; Nov 2013
; ===============================================================
; 
; long labs(long j)
;
; Return absolute value of j.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_labs

EXTERN l_neg_dehl

asm_labs:

   ; enter : dehl = long
   ;
   ; exit  : dehl = abs(dehl)
   ;
   ; uses  : af, de, hl, carry unaffected (not 808x)
  
IF __CPU_INTEL__
   ld a,d
   rla
   ret nc
ELSE 
   bit 7,d
   ret z
ENDIF
   
   jp l_neg_dehl
