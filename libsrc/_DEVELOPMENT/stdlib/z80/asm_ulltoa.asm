
; ===============================================================
; May 2016
; ===============================================================
; 
; char *ulltoa(uint64_t num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.  Does not skip initial whitespace.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ulltoa
PUBLIC asm0_ulltoa, asm1_ulltoa

EXTERN l_divu_64_64x64, l_testzero_64_mhl
EXTERN error_zc, l_valid_base, error_einval_zc, l_num2char

asm_ulltoa:

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
   ;                 | ...  num (8 bytes)
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

   ld a,d                      ; check for NULL buf
   or e
   jp z, error_zc

asm0_ulltoa:                   ; bypasses NULL check of buf

   call l_valid_base           ; radix in [2,36]?
   jp nc, error_einval_zc  

asm1_ulltoa:                   ; entry for lltoa()

   push ix                     ; save ix
   push de                     ; save char *buf
   
   ld hl,0
   
   push hl
   push hl
   push hl
   push bc                     ; push (uint64_t)(radix)
   
   ld hl,-8
   add hl,sp
   ld sp,hl                    ; make space for (uint64_t)(num copy)
   
   push hl
   pop ix                      ; ix = & num copy
   ex de,hl                    ; de = & num copy

   ld hl,22
   add hl,sp                   ; hl = & num
   
   ld bc,8
   ldir                        ; num copy = num
   
   ; use generic radix method
   
   ;      +------------------------
   ;      | +29
   ;      | ...  num (8 bytes)
   ;      | +22
   ;      |------------------------
   ;      | +21
   ;      | +20  return address
   ;      |------------------------
   ;      | +19
   ;      | +18  saved ix
   ;      |------------------------
   ;      | +17
   ;      | +16  char *buf
   ;      |------------------------
   ;      | +15 
   ;      | ...  radix (8 bytes)
   ;      | +8 
   ;      |------------------------
   ;      | +7
   ;      | ...  num (8 bytes)
   ; ix = | +0
   ;      +------------------------
   ;
   ; stack = same address as ix
   
   ; generate digits onto stack in reverse order
   ; max stack depth is 34 bytes for base 2

   xor a                       ; end of digits marked by carry reset
   push af

compute_lp:

   ;      +------------------------
   ;      | +15 
   ;      | ...  radix (8 bytes)
   ;      | +8 
   ;      |------------------------
   ;      | +7
   ;      | ...  num (8 bytes)
   ; ix = | +0
   ;      +------------------------
   
   call l_divu_64_64x64
   
   ; dehl'dehl = num % radix
   ;       num = num / radix
   
   ld a,l                      ; a = digit
   call l_num2char             ; to ascii
   
   scf
   push af                     ; digit onto stack
   
   push ix
   pop hl                      ; hl = & num
   
   call l_testzero_64_mhl      ; keep going until num is zero
   jr nz, compute_lp
   
   ; write digits to string

   ld e,(ix+16)
   ld d,(ix+17)                ; de = char *buf
   
   ; stack = list of digits
   
write_lp:

   pop af
   
   ld (de),a
   inc de
   
   jr c, write_lp
   
   ; last write above was NUL and carry is reset
   
   dec de
   
   ; repair the stack
   
   ld hl,18
   add hl,sp
   ld sp,hl
   
   pop ix                      ; restore ix
   
   ex de,hl                    ; hl = & terminating NUL in buf
   ret
