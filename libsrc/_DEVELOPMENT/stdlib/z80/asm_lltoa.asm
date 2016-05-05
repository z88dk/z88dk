
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *lltoa(uint64_t num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.  Does not skip initial whitespace.
;
; If radix==10, the number is treated as signed and a minus
; sign may be written to the buffer.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_lltoa, asm0_lltoa

EXTERN error_zc, error_einval_zc
EXTERN l_neg_64_mhl, l_valid_base, asm1_ulltoa

asm_lltoa:

   ; enter :         +------------------------
   ;                 | +9
   ;                 | ...  num (8 bytes)
   ;                 | +2
   ;                 |------------------------
   ;                 | +1
   ;         stack = | +0   return address
   ;                 +------------------------
   ;
   ;         bc = int radix [2,36]
   ;         de = char *buf
   ;
   ; exit  :         +------------------------
   ;                 | +7
   ;                 | ...  abs(num) (8 bytes)
   ;         stack = | +0
   ;                 +------------------------
   ;
   ;         hl = address of terminating 0 in buf
   ;         carry reset no errors
   ;
   ; error : (*) if buf == 0
   ;             carry set, hl = 0
   ;
   ;         (*) if radix is invalid
   ;             carry set, hl = 0, errno=EINVAL
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ld a,d
   or e
   jp z, error_zc              ; if buf == NULL
   
asm0_lltoa:                    ; bypasses NULL check on buf

   call l_valid_base           ; radix in [2,36]?
   jp nc, error_einval_zc

   ; base 10 is signed
   
   cp 10
   jp nz, asm1_ulltoa          ; if not base 10

   ld hl,9
   add hl,sp                   ; hl = & MSB(num)
   
   bit 7,(hl)
   jp z, asm1_ulltoa           ; if num is positive
   
   ld hl,2
   add hl,sp                   ; hl = & num
   
   call l_neg_64_mhl           ; num = abs(num)
   
   ld a,'-'
   
   ld (de),a                   ; write minus sign to buffer
   inc de
   
   jp asm1_ulltoa
