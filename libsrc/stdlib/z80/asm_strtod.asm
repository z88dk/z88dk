
; ===============================================================
; Jun 2015
; ===============================================================
; 
; double strtod(const char *nptr, char **endptr)
;
; Read double from string per C11.  Rounding is not applied.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtod

EXTERN l_eat_ws, l_eat_sign, asm_dneg, asm_dsigdig, asm_tolower, asm_isdigit
EXTERN __strtod_hex, __strtod_dec_ip_lz, __strtod_dec_fp_only
EXTERN __strtod_dec_ip, __strtod_special_form, derror_einval_zc

; supplied by math library: asm_dneg, asm_dsigdig

asm_strtod:

   ; Reads float from ascii string per C11 (no rounding applied)
   ; 
   ; enter : de = char **endptr
   ;         hl = char *nptr
   ;
   ; exit  : de = char * (first unconsumed char)
   ;         *endptr as per C11
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
   ; uses  : af, bc, de, hl, ixl, af', bc', de', hl'

   ld a,d
   or e
   jr z, endp_none
   
   ;; char **endp
   
   push de                     ; save endp
   call endp_none
   
   ;; strtod() done, must write endp
   
   ;    de = char * (first uninterpretted char)
   ;   exx = double x
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
   
   ;; negative
   
   call positive
   
   ;    de = char * (first uninterpretted char)
   ;   exx = double x
   ; carry = error

   ex af,af'

   call asm_dneg               ; x = -x
   
   ex af,af'
   ret

positive:

   call asm_dsigdig            ; inquire number of significant digits

   ;  b = num sig hex digits
   ;  c = num sig dec digits
   ; de = original char *
   ; hl = char *

   ;; classify as decimal string, hex string or special form

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_STRTOD & $02)

check_dhs:

   ld a,(hl)
   
   cp '0'
   jr nz, check_ds             ; if cannot be hex string

check_dh:

   inc hl
   
   ld a,(hl)
   call asm_tolower
   
   cp 'x'
   jp z, __strtod_hex          ; if leading '0x' seen

   ld b,c                      ; b = number of significant decimal digits
   dec b

   jp __strtod_dec_ip_lz       ; enter at decimal integer part leading zeroes

check_ds:

   ld b,c                      ; b = number of significant decimal digits
   dec b
   
   cp '.'
   jp z, __strtod_dec_fp_only  ; enter at decimal fraction part only
   
   call asm_isdigit
   jp nc, __strtod_dec_ip      ; enter at decimal integer part

ELSE

   ld b,c                      ; b = number of significant decimal digits
   dec b

   ld a,(hl)

   call asm_isdigit
   jp nc, __strtod_dec_ip_lz   ; enter at decimal integer part leading zeroes
   
   cp '.'
   jp z, __strtod_dec_fp_only  ; enter at decimal fraction part only

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_STRTOD & $01)

   jp __strtod_special_form    ; numerical string ruled out

ELSE

   jp derror_einval_zc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
