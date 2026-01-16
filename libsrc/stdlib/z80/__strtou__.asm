
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdlib

PUBLIC __strtou__

EXTERN l_valid_base, l_eat_ws, l_eat_sign, l_neg_hl, l_eat_base_prefix
EXTERN l_char2num, l_mulu_24_16x8, l_eat_digits

__strtou__:

   ; _strtoi, _strtou helper
   ;
   ; enter : bc = base
   ;         de = char **endp
   ;         hl = char *
   ;
   ; exit  : carry reset indicates no error
   ;
   ;              a = 0 (number not negated) or 1 (number negated)
   ;             hl = result
   ;             de = char * (& next unconsumed char in string)
   ;
   ;         carry set indicates error, a holds error code
   ;
   ;              a = 0/-1 for invalid string, -2 for invalid base
   ;             hl = 0
   ;             de = original char *
   ;
   ;              a = 3 indicates negate on unsigned overflow
   ;             de = char * (& next unconsumed char following number)
   ;
   ;              a = 2 indicates unsigned overflow
   ;             de = char * (& next unconsumed char following number)
   ;
   ;              a = 1 indicates negative underflow
   ;             de = char * (& next unconsumed char following number)
   ;
   ; uses  : af, bc, de, hl

   ld a,d
   or e
   jr z, no_endp

   ; have char **endp
   
   push de                     ; save char **endp
   call no_endp
   
   ; strtou() done, now we must write endp
   
   ; de = char * (first uninterpretted char)
   ; hl = result
   ;  a = error code
   ; carry set = overflow or error
   ; stack = char **endp
   
   ex (sp),hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl
   ret

no_endp:

   call l_valid_base
   
   ld c,a                      ; c = base
   ld e,l
   ld d,h                      ; de = original char *
   
   jr z, valid_base            ; accept base == 0
   jr nc, invalid_base
   
valid_base:

   ; de = original char *
   ; hl = char *
   ;  c = base
   
   call l_eat_ws               ; skip whitespace
   call l_eat_sign             ; carry set if negative
   jr nc, positive
   
   ; negative sign found
   
   call positive
   
   ; return here to negate result
   
   ; de = char * (first uninterpretted char)
   ; hl = result
   ;  a = error code
   ; carry set = overflow or error

   inc a                       ; indicate negate applied
   ret c                       ; return if unsigned overflow

   ; successful conversion, check for signed overflow
   
   ld a,h
   add a,a                     ; carry set if signed overflow
   
   call l_neg_hl               ; negate, carry unaffected
      
   ld a,1
   ret

positive:

   ; de = original char *
   ; hl = char *
   ;  c = base

   ld a,c                      ; a = base
   call l_eat_base_prefix
   ld c,a                      ; c = base
   
   ; there must be at least one valid digit
   
   ld a,(hl)
   call l_char2num
   jr c, invalid_input
   
   cp c
   jr nc, invalid_input
   
   ; there is special code for base 2, 8, 10, 16
   
   ld e,a
   ld a,c
   
   ex de,hl

IF __CLIB_OPT_TXT2NUM & $04

   cp 10
   jr z, decimal

ENDIF

IF __CLIB_OPT_TXT2NUM & $08

   cp 16
   jr z, hex

ENDIF

IF __CLIB_OPT_TXT2NUM & $02
   
   cp 8
   jr z, octal

ENDIF

IF __CLIB_OPT_TXT2NUM & $01
   
   cp 2
   jr z, binary

ENDIF
   
   ; use generic algorithm
   
   ; de = char *
   ;  c = base
   ;  l = first numerical digit
   
   inc de
   ld h,0
   
loop:

   ; hl = result
   ; de = char *
   ;  c = base
   
   ; get next digit
   
   ld a,(de)
   call l_char2num
   jr c, number_complete       ; if not valid digit
   
   cp c
   jr nc, number_complete      ; if not valid digit
   
   inc de                      ; consume char
   
   ; multiply pending result by base
   
   ld b,a                      ; b = digit
   push bc                     ; save digit and base
   push de                     ; save char *
   
   ld e,c                      ; e = base
   call l_mulu_24_16x8         ; AHL = HL * E
   
   pop de                      ; de = char *
   pop bc                      ; bc = digit and base
   
   or a                        ; result confined to 16 bits ?
   jr nz, unsigned_overflow
   
   ld a,b                      ; a = digit to add
   
   ; add digit to result
   
   add a,l
   ld l,a
   jr nc, loop
   
   inc h
   jr nz, loop

unsigned_overflow:

   ; de = char * (next unconsumed char)
   ;  c = base

   ; consume the entire number before reporting error

   ex de,hl                    ; hl = char *
   call l_eat_digits
   
   ex de,hl
   ld a,2
   scf
   
   ; de = char * (next unconsumed char)
   ;  a = 2
   ; carry set for error
   
   ret

invalid_base:

   call invalid_input
   
   ld a,-2
   ret

invalid_input:

   ; de = original char *

   xor a
   ld l,a
   ld h,a
   scf

   ; de = original char *
   ; hl = 0
   ;  a = 0 (error invalid input string)
   ; carry set for error

   ret

number_complete:

   ; hl = result
   ; de = char *

   xor a                       ; carry reset no error
   ret


IF __CLIB_OPT_TXT2NUM & $04

decimal:

   ; de = char *

   EXTERN l_atou
   
   call l_atou
   jr c, unsigned_overflow

   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $08

hex:

   ; de = char *
   
   EXTERN l_htou
   
   call l_htou
   jr c, unsigned_overflow
   
   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $02

octal:

   ; de = char *
   
   EXTERN l_otou
   
   call l_otou
   jr c, unsigned_overflow
   
   xor a
   ret

ENDIF


IF __CLIB_OPT_TXT2NUM & $01

binary:

   ; de = char *
   
   EXTERN l_btou
   
   call l_btou
   jr c, unsigned_overflow
   
   xor a
   ret

ENDIF
