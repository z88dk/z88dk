
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *ltoa(unsigned long num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.  Does not skip initial whitespace.
;
; If radix==10, the number is treated as signed and a minus
; sign may be written to the buffer.
;
; ===============================================================

XLIB ltoa_callee
XDEF asm_ltoa, asm0_ltoa

LIB error_zero_de, error_zc, l_valid_base, asm1_ultoa, l_neg_dehl

ltoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

asm_ltoa:

   ; enter : dehl = long num
   ;           ix = char *buf
   ;           bc = int radix
   ;
   ; exit  : hl = address of terminating 0 in buf
   ;         carry reset no errors
   ;
   ; error : (*) if buf == 0
   ;             carry set, dehl = 0
   ;
   ;         (*) if radix is invalid
   ;             carry set, dehl = 0, errno=EINVAL
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,ixh                    ; check for NULL buf
   or ixl
   call z, error_zero_de
   jp z, error_zc

asm0_ultoa:                    ; bypasses NULL check of buf

   call l_valid_base           ; radix in [2,36]?
   call nc, error_zero_de
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
