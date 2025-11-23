
SECTION code_clib
SECTION code_stdlib

PUBLIC __strtod_special_form

EXTERN __dtoa_infinity_s, __dtoa_nan_s, asm_nan_b
EXTERN asm_strncasecmp, derror_pinfnc, derror_einval_zc

; supplied by math library:  asm_nan_b, derror_pinfnc, derror_einval_zc

__strtod_special_form:

   ; de = original char *
   ; hl = char *

   push de                     ; save original char *
   push hl                     ; save char *
   
   ex de,hl                    ; de = char *
   
   ld hl,__dtoa_infinity_s
   ld bc,8
   call asm_strncasecmp
   
   jp z, derror_pinfnc - 2       ; return +inf
   
   pop de                        ; de = char *
   push de
   
   ld hl,__dtoa_infinity_s
   ld c,3
   call asm_strncasecmp
   
   jp z, derror_pinfnc - 2       ; return +inf

   pop de                        ; de = char *
   push de
   
   ld hl,__dtoa_nan_s
   ld c,3
   call asm_strncasecmp
   
   pop hl
   pop hl
   
   ex de,hl
   
   ; de = original char *
   ; hl = char * (first char after matching "nan")
   
   jp nz, derror_einval_zc     ; reject float string

   ;; nan(...)

   ; hl = char * (first char after matching "nan")

   call asm_nan_b

   ex de,hl                    ; de = char * after nan(...)
   ret
