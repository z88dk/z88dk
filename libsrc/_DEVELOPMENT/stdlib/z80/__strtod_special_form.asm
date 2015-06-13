
SECTION code_stdlib

PUBLIC __strtod_special_form

EXTERN __ftoa_infinity_s, __ftoa_nan_s, nan_b
EXTERN asm_strncasecmp, float_error_pinfnc, float_error_einval_zc

__strtod_special_form:

   ; de = original char *
   ; hl = char *

   push de                     ; save original char *
   push hl                     ; save char *
   
   ex de,hl                    ; de = char *
   
   ld hl,__ftoa_infinity_s
   ld bc,8
   call asm_strncasecmp
   
   jp z, float_error_pinfnc - 2  ; return +inf
   
   pop de                        ; de = char *
   push de
   
   ld hl,__ftoa_infinity_s
   ld c,3
   call asm_strncasecmp
   
   jp z, float_error_pinfnc - 2  ; return +inf

   pop de                        ; de = char *
   push de
   
   ld hl,__ftoa_nan_s
   ld c,3
   call asm_strncasecmp
   
   pop hl
   pop hl
   
   ex de,hl
   
   ; de = original char *
   ; hl = char * (first char after matching "nan")
   
   jp nz, float_error_einval_zc  ; reject float string

   ;; nan(...)

   ; hl = char * (first char after matching "nan")

   call nan_b

   ex de,hl                    ; de = char * after nan(...)
   ret
