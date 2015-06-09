
; ===============================================================
; Jun 2015
; ===============================================================
; 
; double strtod(const char *nptr, char **endptr)
;
; Read float from string per C11.
;
; Hex float string not yet supported and rounding is not applied.
;
; ===============================================================

SECTION code_stdlib

PUBLIC asm_strtod

EXTERN l_eat_ws, l_eat_sign, asm_strcasecmp, asm_isdigit, l_eat_ddigits
EXTERN minusfa, sigdig, ufloat16, mul10, dpush, dadd, tenf, asm_tolower
EXTERN __ftoa_inf_s, __ftoa_infinity_s, __ftoa_nan_s, asm0_atoi
EXTERN float_error_pinfnc, float_error_nannc, float_error_einval_zc

; supplied by math library: minusfa, sigdig, ufloat, mul10, dpush, dadd, tenf,
;   float_error_pinfnc, float_error_nannc, float_error_einval_zc

asm_strtod:

   ; Reads float from ascii string per C11
   ; (hex float string not supported yet, no rounding applied)
   ; 
   ; enter : de = char **endptr
   ;         hl = char *nptr
   ;
   ; exit  : de = char * (first unconsumed char)
   ;         *endp as per C11
   ;
   ;         success
   ;
   ;            exx = float x
   ;            carry reset
   ;
   ;         fail if range error
   ;
   ;            exx = +- infinity
   ;            carry set, errno = ERANGE
   ;
   ;         fail if invalid string
   ;
   ;            exx = 0.0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if nan not supported
   ;
   ;            exx = 0.0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld a,d
   or e
   jr z, endp_none
   
   ; have char **endp
   
   push de                     ; save char **endp
   call endp_none
   
   ; strtod() done, must write endp
   
   ;    de = char * (first uninterpretted char)
   ;   exx = float x
   ; carry = error
   ; stack = char **endp
   
   pop hl                      ; hl = char **endp

   ld (hl),e
   inc hl
   ld (hl),d
   
   ret

endp_none:

   ld e,l
   ld d,h
   
   ; de = original char *
   ; hl = char *
   
   call l_eat_ws               ; skip whitespace
   
   call l_eat_sign             ; carry set if negative
   jr nc, positive
   
   ; negative

   call positive
   
   ;    de = char * (first uninterpretted char)
   ;   exx = float x
   ; carry = error

   ex af,af'

   call minusfa                ; x = -x
   
   ex af,af'
   ret

check_special_form:

   ; de = original char *
   ; hl = char *

   push de                     ; save original char *
   push hl                     ; save char *
   
   ex de,hl                    ; de = char *
   
   ld hl,__ftoa_inf_s
   call asm_strcasecmp
   
   jp z, float_error_pinfnc - 2  ; return +inf
   
   pop de                        ; de = char *
   push de
   
   ld hl,__ftoa_infinity_s
   call asm_strcasecmp
   
   jp z, float_error_pinfnc - 2  ; return +inf
   
   pop de                        ; de = char *
   push de
   
   ld hl,__ftoa_nan_s
   call asm_strcasecmp
   
   jp z, float_error_nannc - 2   ; return +nan
   
   ;; invalid
   
   pop de
   pop de                      ; de = original char *
   
   jp float_error_einval_zc    ; reject float string

fraction_only:

   ; decimal point seen

   ; de = original char *
   ; hl = char *

   inc hl
   ld a,(hl)
   
   call asm_isdigit
   jp c, float_error_einval_zc ; reject float string
      
   call sigdig
   ld b,c                      ; b = max num decimal significant digits

   ld c,$ff                    ; indicate decimal seen

   ; eliminate leading fraction zereos

   cp '0'
   jr nz, fraction_rejoin

lfz:

   dec c                       ; * 10^(-1)
   
   inc hl
   cp (hl)
   
   jr z, lfz
   
   dec hl
   jr fraction_rejoin

positive:

   ; de = original char *
   ; hl = char *

   ; there must be at least one valid digit

   ld a,(hl)
   
;;;   cp '0'
;;;   jp z, check_hex_float       ; look for leading 0x
   
   cp '.'
   jr z, fraction_only         ; if no integer part
   
   call asm_isdigit
   jr c, check_special_form    ; if not a decimal digit

   ; eliminate leading integer zeroes

   cp '0'
   jr nz, integer_rejoin

liz:

   inc hl
   
   cp (hl)
   jr z, liz
   
   dec hl

integer_rejoin:

   call sigdig
   ld b,c                      ; b = max num decimal significant digits

   ld c,127                    ; indicate decimal point not seen

fraction_rejoin:

   ;   a = char digit
   ;   b = remaining significant digits
   ;   c = if < 0, base 10 exponent adjust - 1
   ;  hl = char *

   ; form float from first digit

   push bc
   push hl                     ; save char *

   sub '0'   
   ld l,a
   ld h,0                      ; hl = integer digit
   
   call ufloat16               ; exx set = (float)(integer)

   pop hl                      ; hl = char *
   pop bc

decimal_mantissa:

   inc hl                      ; advance to next char

   ;   b = remaining significant digits
   ;   c = if < 0, base 10 exponent adjust - 1
   ;  hl = char *
   ; exx = float x
   
   ld a,(hl)
   
   call asm_isdigit
   jr nc, valid_digit

   bit 7,c
   jr nz, exponent_adjust      ; if c < 0 already seen a decimal point
   
   cp '.'
   jr nz, exponent_adjust
   
   ld c,$ff
   jr decimal_mantissa

valid_digit:

   push bc
   push hl                     ; save char *
   push af                     ; save digit

   call mul10                  ; x *= 10
   
   pop af                      ; a = digit
   
   call dpush                  ; push x

   sub '0'
   ld l,a
   ld h,0                      ; hl = integer digit
   
   call ufloat16               ; exx = (float)(digit)
   call dadd                   ; exx = x + digit
   
   pop hl                      ; hl = char *
   pop bc
   
   dec c                       ; base 10 exponent adjust --
   djnz decimal_mantissa       ; if more significant digits
   
   ;; exhausted significant digits

   inc hl

exponent_adjust:

   ;; fix exponent adjust

   ;   c = if < 0, base 10 exponent adjust - 1
   ;  hl = char *
   ; exx = float x

   ld b,0                      ; b = base 10 positive exponent adjust

   bit 7,c
   jr nz, consume_fp           ; if already seen a decimal point
   
   ld c,$ff

   ;; consume extra integer part digits
   
   ;   b = base 10 positibe exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ; exx = float x

consume_ip:

   ld a,(hl)
   
   call asm_isdigit
   jr c, consume_point         ; if not digit
   
   inc b
   inc hl
   
   jr consume_ip

consume_point:

   cp '.'
   jr nz, exponent             ; if not decimal point
   
   inc hl                      ; move past decimal point

consume_fp:

   call l_eat_ddigits          ; consume excess fraction digits

exponent:

   ;; EePp

   ld de,0
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = 0
   ; exx = float x

   ld a,(hl)
   call asm_tolower
   
   cp 'e'
   jr z, read_exponent
   
   cp 'p'
   jr nz, suffix

read_exponent:

   inc hl

   ;; read decimal exponent
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = 0
   ; exx = float x

   push bc                     ; save exponent adjust
   
   call asm0_atoi              ; hl = decimal exponent
   
   ex de,hl
   call l_eat_ddigits
   
   pop bc
   
suffix:

   ;; read optional suffix
   
   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  hl = char *
   ;  de = exponent
   ; exx = float x

   ld a,(hl)
   call asm_tolower
   
   cp 'f'
   jr z, valid_suffix
   
   cp 'l'
   jr nz, finalize

valid_suffix:

   inc hl

finalize:

   ex de,hl

   ;; apply exponent
   ;; assertion: -128 <= exp <= 127

   ;   b = base 10 positive exponent adjust
   ;   c = base 10 negative exponent adjust - 1
   ;  de = char *
   ;  hl = exponent
   ; exx = float x

   ld a,b
   ld b,$ff

nexp:

   inc c
   jp p, pexp                  ; if there is no negative adjust
   
   add hl,bc

pexp:

   ld c,a
   inc b
   add hl,bc                   ; hl = final base 10 exponent
   
   push de
   
   ld a,l
   or a
   
   call nz, tenf               ; x *= 10^A
   
   pop de
   ret
