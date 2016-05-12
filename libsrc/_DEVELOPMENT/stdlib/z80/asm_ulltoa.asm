
; ===============================================================
; May 2016
; ===============================================================
; 
; char *ulltoa(uint64_t num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ulltoa
PUBLIC asm0_ulltoa, asm1_ulltoa

EXTERN error_zc, error_einval_zc, l_valid_base
EXTERN l0_divu_64_64x8, l_num2char, l_testzero_64_dehldehl

asm_ulltoa:
   
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
   
   ld a,ixh                    ; check for NULL buf
   or ixl
   jp z, error_zc

asm0_ulltoa:                   ; bypass NULL check

   call l_valid_base           ; radix in [2,36] ?
   jp nc, error_einval_zc

asm1_ulltoa:                   ; entry for lltoa()

   ; use generic radix method
   
   ; generate digits onto stack in reverse order
   ; max stack depth is 66 bytes for base 2

   xor a
   push af                     ; end of digits marked by carry reset

compute_lp:

   ; ix = char *buf
   ; dehl'dehl = number
   ; bc = radix
   
   push bc                    ; save radix
   call l0_divu_64_64x8       ; dehl'dehl = num / radix, a = num % radix
   pop bc
   
   call l_num2char
   scf
   push af                    ; digit onto stack
   
   call l_testzero_64_dehldehl
   jr nz, compute_lp          ; repeat until num is zero
   
   ; write digits to string
   
   ;    ix = char *
   ; stack = list of digits

   push ix
   pop hl

write_lp:

   pop af
   
   ld (hl),a
   inc hl
   
   jr c, write_lp
   
   ; last write above was NUL and carry is reset
   
   dec hl
   ret
