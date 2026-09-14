; ftoe(x, f, str) -- %e exponent text via the math32 C11 dtoa engine.

SECTION code_clib
SECTION code_fp_math32

PUBLIC ftoe
PUBLIC _ftoe

EXTERN asm_dtoe, dload

ftoe:

   ; void ftoe(double x, int f, char *str)
   ; enter: sp+2 = char *str, sp+4 = int f, sp+6 = double x

   ld hl,6
   add hl,sp
   call dload              ; DEHL' = x

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)               ; de = str
   ld hl,4
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                  ; hl = f
   ex de,hl                ; de = f (precision), hl = str (buffer)

   xor a
   ld c,a                  ; c = flag = 0

   jp asm_dtoe

defc _ftoe = ftoe