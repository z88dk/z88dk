
; ===============================================================
; May 2016
; ===============================================================
; 
; char *lltoa(uint64_t num, char *buf, int radix)
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

PUBLIC asm_lltoa, asm0_lltoa, asm1_lltoa

EXTERN error_zc, error_einval_zc, l_valid_base
EXTERN asm1_ulltoa, l_neg_64_dehldehl

asm_lltoa:

   ; enter : dehl'dehl = unsigned long long num
   ;         ix = char *buf
   ;         bc = int radix
   ;
   ; exit  : hl = address of terminating 0 in buf
   ;         carry reset no errors
   ;
   ; error : (*) if buf == 0
   ;             carry set, hl = 0
   ;
   ;         (*) if radix is invalid
   ;             carry set, hl = 0, errno=EINVAL
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,ixh
   or ixl
   jp z, error_zc              ; if buf == NULL
   
asm0_lltoa:                    ; bypass NULL check

   call l_valid_base           ; radix in [2,36]?
   jp nc, error_einval_zc

asm1_lltoa:

   ; base 10 is signed
   
   cp 10
   jp nz, asm1_ulltoa          ; if not base 10
   
   exx
   bit 7,d
   exx
   jp z, asm1_ulltoa           ; if num is positive
   
   call l_neg_64_dehldehl
   
   ld (ix+0),'-'
   inc ix
   
   call asm1_ulltoa
   
   dec ix
   ret
