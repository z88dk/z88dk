
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdlib

PUBLIC __strtoul__

EXTERN l_valid_base, l_eat_ws, l_eat_sign, l_eat_digits, error_lzc
EXTERN l_neg_dehl, l_char2num, l_mulu_40_32x8, l_eat_base_prefix

__strtoul__:

   ; strtol, strtoul helper
   ;
   ; enter : bc = base
   ;         de = char **endp
   ;         hl = char *
   ;
   ; exit  : carry reset indicates no error
   ;
   ;              a = 0 (number not negated) or 1 (number negated)
   ;           dehl = result
   ;            ixl = base
   ;             bc = char * (& next unconsumed char in string)
   ;
   ;         carry set indicates error, a holds error code
   ;
   ;              a = 0/-1 for invalid string, -2 for invalid base
   ;           dehl = 0
   ;            ixl = base
   ;             bc = original char *
   ;
   ;              a = 3 indicates negate on unsigned overflow
   ;            ixl = base
   ;             bc = char * (& next unconsumed char following number)
   ;
   ;              a = 2 indicates unsigned overflow
   ;            ixl = base
   ;             bc = char * (& next unconsumed char following number)
   ;
   ;              a = 1 indicates negative underflow
   ;            ixl = base
   ;             bc = char * (& next unconsumed char following number)
   ;
   ; uses  : af, bc, de, hl, ix

   ld a,d
   or e
   jr z, no_endp
   
   ; have char **endp
   
   push de                     ; save char **endp
   call no_endp
   
   ; strtoul() done, now must write endp
   
   ;   bc = char * (first uninterpretted char)
   ; dehl = result
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

   ;  bc = original char *
   ;  hl = char *
   ; ixl = base

   call l_eat_ws               ; skip whitespace
   call l_eat_sign             ; carry set if negative
   jr nc, positive
   
   ; negative sign found
      
   call positive
   
   ; return here to negate result

   ;   bc = char * (first uninterpretted char)
   ; dehl = result
   ;    a = error code (if carry set)
   ; carry set = overflow or error

   inc a                       ; indicate negate applied
   ret c                       ; return if error
   
   ; successful conversion, check for signed overflow

   ld a,d
   add a,a                     ; carry set if signed overflow
   
   call l_neg_dehl             ; negate, carry unaffected

   ld a,1
   ret

positive:

   ;  bc = original char*
   ;  hl = char *
   ; ixl = base

   ld a,ixl                    ; a = base
   call l_eat_base_prefix
   ld ixl,a                    ; ixl = base
   
   ; there must be at least one valid digit
   
   ld a,(hl)
   call l_char2num
   jr c, invalid_input
   
   cp ixl
   jr nc, invalid_input
   
   ; there is special code for base 2, 8, 10, 16

   ld e,a
   ld a,ixl

IF __CLIB_OPT_TXT2NUM & $40

   cp 10
   jr z, decimal

ENDIF

IF __CLIB_OPT_TXT2NUM & $80
   
   cp 16
   jr z, hex

ENDIF

IF __CLIB_OPT_TXT2NUM & $20
   
   cp 8
   jr z, octal

ENDIF

IF __CLIB_OPT_TXT2NUM & $10
   
   cp 2
   jr z, binary

ENDIF

   ; use generic algorithm
   
   ;  hl = char *
   ; ixl = base
   ;   e = first numerical digit
   
   ld c,l
   ld b,h
   inc bc                      ; bc = & next char to consume
   
   ld d,0
   ld l,d
   ld h,d
   ex de,hl                    ; dehl = initial digit
   
loop:

   ; dehl = result
   ;   bc = char *
   ;  ixl = base
   
   ; get next digit
   
   ld a,(bc)
   call l_char2num             ; a = digit
   jr c, number_complete
   
   cp ixl                      ; digit in 0..base-1 ?
   jr nc, number_complete
   
   inc bc                      ; consume the char
   
   ; multiply pending result by base
   
   push af                     ; save new digit
   push bc                     ; save char *
   
   ld a,ixl                    ; a = base
   call l_mulu_40_32x8         ; ADEHL = DEHL * A
   
   pop bc                      ; bc = char *
   
   or a                        ; result confined to 32 bits ?
   jr nz, unsigned_overflow
   
   pop af                      ; a = digit to add
   
   ; add digit to result
   
   add a,l                     ; dehl += a
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop
   
   inc e
   jr nz, loop
   
   inc d
   jr nz, loop

   push af

unsigned_overflow:

   ;   bc = char * (next unconsumed char)
   ;  ixl = base
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
   ; dehl = 0
   ;    a = 0 (error invalid input string)
   ; carry set for error
   
   jp error_lzc

number_complete:

   xor a                       ; carry reset and a=0
   ret


IF __CLIB_OPT_TXT2NUM & $40

decimal:

   ;  hl = char *
   
   EXTERN l_atoul
   
   ex de,hl
   call l_atoul
   jr c, u_oflow
   
   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $80

hex:

   ;  hl = char *
   
   EXTERN l_htoul
   
   ex de,hl
   call l_htoul
   jr c, u_oflow
   
   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $20

octal:

   ; hl = char *
   
   EXTERN l_otoul
   
   ex de,hl
   call l_otoul
   jr c, u_oflow
   
   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $10

binary:

   ; hl = char *
   
   EXTERN l_btoul
   
   ex de,hl
   call l_btoul
   jr c, u_oflow
   
   xor a
   ret

ENDIF
