
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *ltoa(unsigned long num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.
;
; If radix==10, the number is treated as signed and a minus
; sign may be written to the buffer.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ltoa
PUBLIC asm0_ltoa

EXTERN error_zc, error_einval_zc
EXTERN l_valid_base, asm1_ultoa, l_neg_dehl

asm_ltoa:

   ; enter : dehl = long num
   ;           ix = char *buf
   ;           bc = int radix
   ;
   ; exit  : ix = char *buf
   ;         hl = address of terminating 0 in buf
   ;         carry reset no errors
   ;
   ; error : (*) if buf == 0
   ;             carry set, hl = 0
   ;
   ;         (*) if radix is invalid
   ;             carry set, hl = 0, errno=EINVAL
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,ixh                    ; check for NULL buf
   or ixl
   jp z, error_zc

asm0_ltoa:                     ; bypasses NULL check of buf

   call l_valid_base           ; radix in [2,36]?
   jp nc, error_einval_zc

   ; base 10 is signed
   
   cp 10
   jp nz, asm1_ultoa

   bit 7,d                     ; number positive?
   jp z, asm1_ultoa
   
   call l_neg_dehl
   
   ld (ix+0),'-'
   inc ix
   
   ld a,10
   call asm1_ultoa

   dec ix
   ret
