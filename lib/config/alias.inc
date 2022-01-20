

#
# Aliases used by the classic library
#
ALIAS   --conio-selector -pragma-redirect:fputc_cons=fputc_cons_selector 
ALIAS   --generic-console -pragma-redirect:fputc_cons=fputc_cons_generic -D__HAVE_GENCON
ALIAS   --hardware-keyboard -pragma-redirect:fgetc_cons=fgetc_cons_inkey -pragma-redirect:getk=getk_inkey 


#
# Math library aliases (classic)
#
ALIAS   --math-mbf32            -Cc-fp-mode=mbf32   -lmbf32 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MBF32 -Ca-D__MATH_MBF32 -D__MATH_MBF32
ALIAS   --math-mbf32_8080       -Cc-fp-mode=mbf32   -lmbf32_8080 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MBF32 -Ca-D__MATH_MBF32 -D__MATH_MBF32
ALIAS   --math-mbf32_8085       -Cc-fp-mode=mbf32   -lmbf32_8085 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MBF32 -Ca-D__MATH_MBF32 -D__MATH_MBF32
ALIAS   --math-mbf32_gbz80      -Cc-fp-mode=mbf32   -lmbf32_gbz80 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MBF32 -Ca-D__MATH_MBF32 -D__MATH_MBF32
ALIAS   --math-mbf64            -Cc-fp-mode=mbf64   -lmbf64
ALIAS   --math-bbc              -Cc-fp-mode=z88     -lbbc_math
ALIAS   --math-dai32            -Cc-fp-mode=am9511  -ldaimath32 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_DAI32 -Ca-D__MATH_DAI32 -D__MATH_DAI32
ALIAS   --math-dai32_8080       -Cc-fp-mode=am9511  -ldaimath32_8080 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_DAI32 -Ca-D__MATH_DAI32 -D__MATH_DAI32
ALIAS   --math-am9511_8085      -Cc-fp-mode=ieee    -lam9511_8085 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_AM9511 -Ca-D__MATH_AM9511 -D__MATH_AM9511

#
# Math library aliases (classic + newlib)
#
ALIAS   --math16                                    -lmath16 --opt-code-speed=inlineints -Cc-D__MATH_MATH16 -Ca-D__MATH_MATH16 -D__MATH_MATH16
ALIAS   --math32                -Cc-fp-mode=ieee    -lmath32 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MATH32 -Ca-D__MATH_MATH32 -D__MATH_MATH32
ALIAS   --am9511                -Cc-fp-mode=ieee    -lam9511 -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_AM9511 -Ca-D__MATH_AM9511 -D__MATH_AM9511

