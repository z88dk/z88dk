

#
# Aliases used by the classic library
#
ALIAS   --generic-console -pragma-redirect:fputc_cons=fputc_cons_generic
ALIAS   --hardware-keyboard -pragma-redirect:fgetc_cons=fgetc_cons_inkey


#
# Math library aliases (classic)
#
ALIAS   --math-mbf32    -Cc-fp-mode=mbf32 -lmbf32
ALIAS   --math-mbf64    -Cc-fp-mode=mbf64 -lmbf64
ALIAS   --math-bbc      -Cc-fp-mode=z88 -lbbc_math

#
# Math library aliases (classic + newlib)
#
ALIAS   --math32        -Cc-fp-mode=ieee -Cc-D__MATH_MATH32 -D__MATH_MATH32 -lmath32 -pragma-define:CLIB_32BIT_FLOAT=1
ALIAS   --math32_fast   -Cc-fp-mode=ieee -Cc-D__MATH_MATH32 -D__MATH_MATH32 -lmath32_fast -pragma-define:CLIB_32BIT_FLOAT=1
ALIAS   --math32_z180   -Cc-fp-mode=ieee -Cc-D__MATH_MATH32 -D__MATH_MATH32 -lmath32_z180 -pragma-define:CLIB_32BIT_FLOAT=1
ALIAS   --math32_z80n   -Cc-fp-mode=ieee -Cc-D__MATH_MATH32 -D__MATH_MATH32 -lmath32_z80n -pragma-define:CLIB_32BIT_FLOAT=1
