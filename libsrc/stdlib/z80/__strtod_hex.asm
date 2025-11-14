
SECTION code_clib
SECTION code_stdlib

PUBLIC __strtod_hex

EXTERN asm_isxdigit, asm_tolower, l_char2num, l_eat_hdigits, asm_dhexpop
EXTERN derror_znc, __strtod_exponent, __strtod_suffix, asm_dmulpow2

; supplied by math library:  asm_dhexpop, asm_dmulpow2, derror_znc

hex_fraction_only:

   ;; leading decimal point seen

   ;  b = num sig hex digits
   ; de = original char *
   ; hl = char *

   inc hl
   ld a,(hl)
   
   call asm_isxdigit
   jr c, hex_return_zero_0     ; reject lone decimal point

hex_fraction_join:

   ld e,0                      ; exponent adjust / 4
   ld c,e                      ; seen decimal point (0)
   
   ;; eliminate leading fraction zeroes
   
hex_fz_loop:

   cp '0'
   jr nz, hex_mantissa

   dec e                       ; * 2^(-4)

   inc hl
   ld a,(hl)
   
   call asm_isxdigit
   jr nc, hex_fz_loop          ; if another hex digit

hex_zero:

   ;; digit portion is all zeroes
   
   call derror_znc             ; exx = 0.0

   ld e,0                      ; no exponent adjust
   jp hex_exponent             ; look for following exponent

hex_return_zero_0:

   ;; leading '0x.?' seen
   
   dec hl
   
hex_return_zero:

   ;; leading '0x?' seen
   
   dec hl
   ex de,hl                    ; de = char *
   
   jp derror_znc               ; return 0.0

__strtod_hex:

   ;; parse 0xhhh.hhhp+dd

   ;  b = num sig hex digits
   ; de = original char *
   ; hl = char *

   ;; leading '0x' seen
   
   inc hl
   ld a,(hl)
   
   cp '.'
   jr z, hex_fraction_only
   
   call asm_isxdigit
   jr c, hex_return_zero       ; if no hex digit but have seen '0'

   ;; eliminate leading integer zeroes
   
hex_iz_loop:

   cp '0'
   jr nz, hex_iz_end

   inc hl
   ld a,(hl)
   
   jr hex_iz_loop

hex_iz_end:

   call asm_isxdigit
   jr nc, hex_integer_join   
   
   cp '.'
   jr nz, hex_zero             ; if '0' string ends in non-digit
   
   inc hl
   ld a,(hl)
   
   call asm_isxdigit
   jr nc, hex_fraction_join
   
   jr hex_zero

hex_integer_join:

   ;  a = char digit
   ;  b = num sig hex digits
   ; de = original char *
   ; hl = char *

   ld e,0                      ; exponent adjust / 4
   ld c,1                      ; decimal point unseen

hex_mantissa:

   inc b                       ; generate one additional hex digit for proper normalization
   srl b                       ; num sig digits /= 2
   jr nc, hex_mantissa_loop
   inc b                       ; if num sig digits was odd, round up

hex_mantissa_loop:

   inc hl

   ;  a = char digit
   ;  b = remaining significant digits / 2
   ;  c = 0 / 1 (0 = decimal point seen)
   ;  e = exponent adjust / 4
   ; hl = char *

   call l_char2num             ; a = number
   
   add a,a
   add a,a
   add a,a
   add a,a
   
   ld d,a                      ; d = hex digit in top nibble
   
   ld a,e
   add a,c
   ld e,a                      ; * 2^4 (if decimal point unseen)

hex_mantissa_1:

   ;  b = remaining significant digits / 2
   ;  d = hex digit (upper nibble filled)
   ;  c = 0 / 1 (0 = decimal point seen)
   ;  e = exponent adjust / 4
   ; hl = char *

   ld a,(hl)
   
   call asm_isxdigit
   jr nc, hex_valid_digit_1
   
   inc c
   dec c
   jr z, hex_push_1            ; if decimal point already seen
   
   cp '.'
   jr nz, hex_push_1
   
   dec c                       ; indicate decimal point seen
   
   inc hl
   jr hex_mantissa_1

hex_valid_digit_1:

   inc hl

   ;  a = char digit
   ;  b = remaining significant digits / 2
   ;  d = hex digit (upper nibble filled)
   ;  c = 0 / 1 (0 = decimal point seen)
   ;  e = exponent adjust / 4
   ; hl = char *

   call l_char2num
   
   or d
   ld d,a
   
   push de
   inc sp
   
   ld a,e
   add a,c
   ld e,a                      ; * 2^4 (if decimal point unseen)
   
   djnz hex_mantissa_0
   
   jr hex_load

hex_mantissa_0:

   ;  b = remaining significant digits / 2
   ;  c = 0 / 1 (0 = decimal point seen)
   ;  e = exponent adjust / 4
   ; hl = char *

   ld a,(hl)
   
   call asm_isxdigit
   jr nc, hex_mantissa_loop
   
   inc c
   dec c
   jr z, hex_push_0            ; if decimal point already seen
   
   cp '.'
   jr nz, hex_push_0
   
   dec c                       ; indicate decimal point seen
   
   inc hl
   jr hex_mantissa_0

hex_push_0:

   ld d,0

hex_push_1:

   push de
   inc sp
   
   djnz hex_push_0

hex_load:

   ;  c = 0 / 1 (0 = decimal point seen)
   ;  e = exponent adjust / 4
   ; hl = char *
   ; stack = hex digits

   call asm_dhexpop
   
   ;   c = 0 / 1 (0 = decimal point seen)
   ;   e = exponent adjust / 4
   ;  hl = char *
   ; exx = double x

   ;; consume extra digits

   dec c
   jr nz, hex_consume_fp       ; if already seen decimal point

hex_consume_ip:

   ld a,(hl)
   
   call asm_isxdigit
   jr c, hex_consume_point     ; if not digit
   
   inc e                       ; * 2^4
   inc hl
   
   jr hex_consume_ip

hex_consume_point:

   cp '.'
   jr nz, hex_exponent
   
   inc hl

hex_consume_fp:

   call l_eat_hdigits          ; consume excess fraction digits

hex_exponent:

   ; Pp

   ld c,e
   ld de,0

   ;   c = exponent adjust / 4
   ;  hl = char *
   ;  de = 0
   ; exx = double x

   ld a,(hl)
   call asm_tolower
   
   cp 'p'
   jr nz, hex_suffix

hex_read_exponent:

   inc hl

   ;; read decimal exponent
   
   ;   c = exponent adjust / 4
   ;  hl = char *
   ;  de = 0
   ; exx = double x

   call __strtod_exponent
   
hex_suffix:

   ;; read optional suffix
   
   ;   c = exponent adjust / 4
   ;  hl = char *
   ;  de = exponent
   ; exx = double x

   call __strtod_suffix

hex_finalize:

   ex de,hl

   ;; apply exponent

   ;   c = exponent adjust / 4
   ;  de = char *
   ;  hl = exponent
   ; exx = double x

   ld a,c
   add a,a
   sbc a,a
   
   sla c
   rla
   sla c
   rla
   ld b,a
   
   add hl,bc
   
   ld a,h
   or l
   
   jp nz, asm_dmulpow2         ; x *= 2^(HL)
   ret
