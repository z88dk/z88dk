
SECTION code_clib
SECTION code_stdlib

PUBLIC __strtoull__

EXTERN l_valid_base, l_eat_ws, l_eat_sign, l_neg_64_dehldehl
EXTERN l_eat_base_prefix, l_char2num, error_llznc, l_mulu_72_64x8
EXTERN l_add_64_dehldehl_a, l_eat_digits, error_llzc

__strtoull__:

   ; strtoll, strtoull helper
   ;
   ; enter : bc = base
   ;         de = char **endp
   ;         hl = char *
   ;
   ; exit  : carry reset indicates no error
   ;
   ;              a = 0 (number not negated) or 1 (number negated)
   ;           dehl'dehl = result
   ;             bc = char * (& next unconsumed char in string)
   ;
   ;         carry set indicates error, A holds error code
   ;
   ;              a = 0/-1 for invalid string, -2 for invalid base
   ;           dehl'dehl = 0
   ;             bc = original char *
   ;
   ;              a = 3 indicates negate on unsigned overflow
   ;             bc = char * (& next unconsumed char following number)
   ;
   ;              a = 2 indicates unsigned overflow
   ;             bc = char * (& next unconsumed char following number)
   ;
   ;              a = 1 indicates negative underflow
   ;             bc = char * (& next unconsumed char following number)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl', ixl

   ld a,d
   or e
   jr z, no_endp
   
   ; have char **endp
   
   push de                     ; save char **endp
   call no_endp
   
   ; strtoul() done, now must write endp
   
   ;   bc = char * (first uninterpretted char)
   ; dehl'dehl = result
   ;    a = error code (if carry set)
   ; carry set = overflow or error
   ; stack = char **endp
   
   ex (sp),hl
   ld (hl),c
   inc hl
   ld (hl),b
   
   pop hl
   ret

no_endp:

   call l_valid_base
   
   ld ixl,a                    ; ixl = base
   ld c,l
   ld b,h                      ; bc = original char *
 
   jr z, valid_base            ; accept base == 0
   jr nc, invalid_base
   
valid_base:

   ; bc = original char *
   ; hl = char *
   ; ixl = base

   call l_eat_ws               ; skip whitespace
   call l_eat_sign             ; carry set if negative
   jr nc, positive
   
   ; negative sign found
   
   call positive
   
   ; return here to negate result

   ;   bc = char * (first uninterpretted char)
   ; dehl'dehl = result
   ;    a = error code (if carry set)
   ; carry set = overflow or error

   inc a                       ; indicate negate applied
   ret c                       ; return if error
   
   ; successful conversion, check for signed overflow
   
   exx
   ld a,d
   exx
   add a,a                     ; carry set if signed overflow
   
   call l_neg_64_dehldehl      ; negate, carry flag unaffected
   
   ld a,1
   ret

positive:

   ; bc = original char *
   ; hl = char *
   ; ixl = base

   ld a,ixl                    ; a = base
   call l_eat_base_prefix
   ld ixl,a                    ; ixl = base, possibly modified
   
   ; there must be at least one valid digit
   
   ld a,(hl)
   call l_char2num
   jr c, invalid_input
   
   cp ixl
   jr nc, invalid_input
   
   ; use generic algorithm
   
   ;  a = first numerical digit
   ; hl = char *
   
   ld c,l
   ld b,h
   inc bc                      ; bc = & next char to consume
   
   call error_llznc
   ld l,a                      ; dehl'dehl = initial digit
     
loop:

   ; bc = char *
   ; dehl'dehl = result
   ; ixl = base

   ; get next digit
   
   ld a,(bc)
   call l_char2num             ; a = digit
   jr c, number_complete
   
   cp ixl                      ; digit in [0,base-1] ?
   jr nc, number_complete
   
   inc bc                      ; consume the char
   
   ; multiply pending result by base
   
   push af                     ; save new digit
   push bc                     ; save char *

   ld a,ixl                    ; a = base
   call l_mulu_72_64x8         ; a dehl'dehl = dehl'dehl * a
   
   pop bc                      ; bc = char *
   
   or a                        ; result > 64 bits ?
   jr nz, unsigned_overflow

   pop af                      ; a = new digit
   
   ; add digit to result

   call l_add_64_dehldehl_a    ; dehl'dehl += a
   jr nz, loop                 ; if no overflow
   
   push af
   
unsigned_overflow:

   ; bc = char * (next unconsumed char)
   ; ixl = base
   ; stack = junk

   pop af

u_oflow:

   ; consume the entire number before reporting error
   
   ld l,c
   ld h,b                      ; hl = char *
   ld c,ixl                    ; c = base
   
   call l_eat_digits

   ld c,l
   ld b,h
   
   ld a,2
   scf
   
   ;   bc = char * (next unconsumed char)
   ;    a = 2 (error overflow)
   ; carry set for error

   ret

invalid_base:

   call invalid_input
   ld a,-2
   ret

invalid_input:

   ;  bc = original char*

   xor a
   
   ;   bc = original char *
   ; dehl'dehl = 0
   ;    a = 0 (error invalid input string)
   ; carry set for error
   
   jp error_llzc

number_complete:

   xor a                       ; carry reset and a=0
   ret
