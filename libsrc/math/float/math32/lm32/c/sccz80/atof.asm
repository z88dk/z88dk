; atof(s) -- decimal string to double via the math32 C11 strtod engine.

SECTION code_clib
SECTION code_fp_math32

PUBLIC atof
PUBLIC _atof

EXTERN asm_strtod, mlib2d

atof:

   ; double atof(const char *nptr) __smallc
   ; enter: sp+2 = char *nptr (caller cleans up)

   pop af                  ; return address
   pop hl                  ; hl = nptr
   push hl                 ; restore stack for caller's cleanup
   push af

   ld de,0                 ; no endptr
   call asm_strtod

   jp mlib2d               ; DEHL = sccz80_float

defc _atof = atof