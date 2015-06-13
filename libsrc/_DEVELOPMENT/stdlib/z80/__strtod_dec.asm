
SECTION code_stdlib

PUBLIC __strtod_dec_ip, __strtod_dec_ip_lz, __strtod_dec_fp_only

EXTERN ufloat16, mul10, dpush, dadd, tenf, l_eat_ddigits
EXTERN asm_isdigit, asm_tolower, __strtod_exponent, __strtod_suffix
EXTERN float_error_einval_zc, float_error_znc, float_error_erange_pinfc

__strtod_dec_fp_only:

   ;; leading decimal point seen

   ;  b = num sig dec digits
   ; de = original char *
   ; hl = char *

   inc hl
   ld a,(hl)
   
   call asm_isdigit
   jp c, float_error_einval_zc ; reject lone decimal point

decimal_fraction_join:

   ld c,$ff                    ; indicate decimal point seen
   
   ;; eliminate leading fraction zeroes
   
decimal_fz_loop:

   cp '0'
   jr nz, __strtod_dec
   
   dec c                       ; * 10^(-1)
   
   inc hl
   ld a,(hl)
   
   call asm_isdigit
   jr nz, decimal_fz_loop      ; if another decimal digit

decimal_zero:

   ;; digit portion is all zeroes
   
   call float_error_znc        ; exx = 0.0
   
   ld bc,$00ff                 ; no exponent adjust
   jr decimal_exponent         ; look for following exponent

__strtod_dec_ip_lz:

   ;; eliminate leading zeroes in integer part

   cp '0'
   jr nz, __strtod_dec_ip_lz_end
   
   inc hl
   ld a,(hl)
   
   jr __strtod_dec_ip_lz

__strtod_dec_ip_lz_end:

   call asm_isdigit
   jr nc, __strtod_dec_ip

   cp '.'
   jr nz, decimal_zero         ; if string of 0s ends in non-digit
   
   inc hl
   ld a,(hl)
   
   call asm_isdigit
   jr nc, decimal_fraction_join
   
   jr decimal_zero

__strtod_dec_ip:

   ld c,127                    ; indicate have not seen decimal point

__strtod_dec:

   ;  a = char digit
   ;  b = number significant decimal digits
   ;  c = if < 0, base 10 exponent adjust - 1
   ; hl = char *
   
   ;; form float from first digit
   
   push bc
   push hl
   
   sub '0'
   ld l,a
   ld h,0                      ; hl = integer digit
   
   call ufloat16               ; exx = (float)(hl)
   
   pop hl
   pop bc

decimal_mantissa:

   inc hl                      ; advance to next char

   ;   b = remaining significant digits
   ;   c = if < 0, base 10 exponent adjust - 1
   ;  hl = char *
   ; exx = float x

   ld a,(hl)
   
   call asm_isdigit
   jr nc, decimal_valid
   
   bit 7,c
   jr nz, decimal_exp_adjust   ; if decimal point already seen
   
   cp '.'
   jr nz, decimal_exp_adjust
   
   ld c,$ff                    ; start decimal point counter
   jr decimal_mantissa

decimal_valid:

   push bc
   push hl
   push af
   
   call mul10                  ; x *= 10
   
   pop af                      ; a = char digit
   
   call dpush                  ; push x
   
   sub '0'
   ld l,a
   ld h,0                      ; hl = integer digit
   
   call ufloat16               ; exx = (float)(hl)
   call dadd                   ; exx += x
   
   pop hl                      ; hl = char *
   pop bc
   
   dec c                       ; base 10 exponent adjust
   djnz decimal_mantissa
   
   ;; exhausted significant digits
   
   inc hl

decimal_exp_adjust:

   ;; fix exponent adjust

   ;   c = if < 0, base 10 exponent adjust - 1
   ;  hl = char *
   ; exx = float x

   ld b,0                      ; b = base 10 positive exp adjust
   
   bit 7,c
   jr nz, decimal_consume_fp   ; if already seen a decimal point
   
   ld c,$ff
   
   ;; consume extra digits

   ;   b = base 10 positibe exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ; exx = float x

decimal_consume_ip:

   ld a,(hl)
   
   call asm_isdigit
   jr c, decimal_consume_pt    ; if not digit
   
   inc b                       ; multiply by 10
   inc hl
   
   jr decimal_consume_ip

decimal_consume_pt:

   cp '.'
   jr nz, decimal_exponent     ; if no decimal point
   
   inc hl

decimal_consume_fp:

   call l_eat_ddigits          ; consume excess fraction digits

decimal_exponent:

   ;; Ee
   
   ld de,0
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = 0
   ; exx = float x

   ld a,(hl)
   call asm_tolower
   
   cp 'e'
   jr nz, decimal_suffix

decimal_read_exponent:

   inc hl

   ;; read decimal exponent
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = 0
   ; exx = float x

   call __strtod_exponent

decimal_suffix:

   ;; read optional suffix
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = exponent
   ; exx = float x

   call __strtod_suffix

decimal_finalize:

   ex de,hl

   ;; apply exponent

   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  de = char *
   ;  hl = exponent
   ; exx = float x

   ld a,b
   ld b,$ff

decimal_nexp:

   inc c
   jp p, decimal_pexp          ; if there is no negative adjust
   
   add hl,bc

decimal_pexp:

   ld c,a
   inc b
   add hl,bc                   ; hl = final base 10 exponent
   
   ld a,l
   add a,a
   sbc a,a
   xor h
   jr nz, decimal_exp_error    ; if |exponent| > 127 
   
   push de
   
   ld a,l
   or a
   
   call nz, tenf               ; x *= 10^A
   
   pop de
   ret

decimal_exp_error:

   ;  de = char *
   ;  hl = exponent

   bit 7,h
   jp nz, float_error_znc      ; if exponent << 0
   
   jp float_error_erange_pinfc
