
; ===============================================================
; May 2016
; ===============================================================
; 
; int ffsll(long long i)
;
; Return bit position of least significant bit set.  Bit
; positions are numbered 1-64 with 0 returned if no bits
; are set.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_ffsll

EXTERN asm_ffsl, error_znc

asm_ffsll:

   ; enter : dehl'dehl = long long
   ;
   ; exit  : hl = bit pos or 0 if no set bits
   ;         carry set if set bit present
   ;
   ; uses  : af, hl, hl'

   ld a,d
   or e
   or h
   or l
   
   jp nz, asm_ffsl
   
   exx
   
   call asm_ffsl
   ld a,l
   
   exx

   jp nc, error_znc
   
   add a,32
   
   ld l,a
   ld h,0
   
   scf
   ret
