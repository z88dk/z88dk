
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *utoa(unsigned int num, char *buf, int radix)
;
; Write number to ascii buffer in radix indicated and zero
; terminate.  Does not skip initial whitespace.
;
; ===============================================================

XLIB asm_utoa
XDEF asm0_utoa, asm1_utoa

LIB error_zc, l_valid_base, error_einval_zc, l0_divu_16_16x8
LIB l_num2char, l_utoa, l_utoh, l_utoo, l_utob

asm_utoa:

   ; enter : hl = uint num
   ;         bc = int radix [2,36]
   ;         de = char *buf
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
   ; uses  : af, bc, de, hl, ix

   ld a,d                      ; check for NULL buf
   or e
   jp z, error_zc

asm0_utoa:                     ; bypasses NULL check of buf

   call l_valid_base           ; radix in [2,36]?
   jp nc, error_einval_zc  
      
   ; there is special code for base 2, 8, 10, 16

asm1_utoa:                     ; entry for itoa()

   cp 10
   jr z, decimal

   cp 16
   jr z, hex

   cp 8
   jr z, octal

   cp 2
   jr z, binary

   ld ixl,e
   ld ixh,d

   ; use generic radix method
   
   ; hl = unsigned int
   ; bc = radix
   ; ix = char *buf

   ; generate digits onto stack in reverse order
   ; max stack depth is 34 bytes for base 2

   ld e,c
   ld d,b

   xor a                       ; end of digits marked by carry reset
   push af

compute_lp:

   ; hl = number
   ; de = radix

   push de                     ; save radix
   call l0_divu_16_16x8        ; hl = num / radix, e = num % radix
   ld a,e                      ; a = digit
   pop de                      ; restore radix

   call l_num2char             ; to ascii
   scf
   push af                     ; digit onto stack
   
   ld a,h                      ; keep going until number is zero
   or l
   jp nz, compute_lp
   
   ; write digits to string
   
   ; ix = char *buf
   ; stack = list of digits

   ld e,ixl
   ld d,ixh
   
write_lp:

   pop af
   
   ld (de),a
   inc de
   
   jp c, write_lp
   
   ; last write above was NUL and carry is reset
   
   dec de
   ex de,hl
   ret


decimal:

   call l_utoa
   
terminate:

   xor a
   ld (de),a
   
   ex de,hl
   ret


hex:
   
   call l_utoh
   jp terminate


octal:

   call l_utoo
   jp terminate


binary:

   call l_utob
   jp terminate
