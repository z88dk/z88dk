

#
# Aliases used by the classic library
#
ALIAS   --generic-console -pragma-redirect:fputc_cons=fputc_cons_generic -pragma-define:CLIB_DISABLE_FGETS_CURSOR=0 
ALIAS   --hardware-keyboard -pragma-redirect:fgetc_cons=fgetc_cons_inkey -pragma-redirect:getk=getk_inkey 


#
# Math library aliases (classic)
#
ALIAS   --math-mbf32            -Cc-fp-mode=mbf32   -lmbf32
ALIAS   --math-mbf32_8080       -Cc-fp-mode=mbf32   -lmbf32_8080
ALIAS   --math-mbf64            -Cc-fp-mode=mbf64   -lmbf64
ALIAS   --math-bbc              -Cc-fp-mode=z88     -lbbc_math

#
# Math library aliases (classic + newlib)
#
ALIAS   --math16                                    -lmath16 -Cc-D__MATH_MATH16 -D__MATH_MATH16 -pragma-define:CLIB_16BIT_FLOAT=1
ALIAS   --math32                -Cc-fp-mode=ieee    -lmath32 -Cc-D__MATH_MATH32 -D__MATH_MATH32 -pragma-define:CLIB_32BIT_FLOAT=1

