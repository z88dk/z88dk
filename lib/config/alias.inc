

#
# Aliases used by the classic library
#
ALIAS   --conio-selector -pragma-redirect:fputc_cons=fputc_cons_selector 
ALIAS   --generic-console -pragma-redirect:fputc_cons=fputc_cons_generic -D__HAVE_GENCON -pragma-define:__HAVE_GENCON=1
ALIAS   --hardware-keyboard -pragma-redirect:fgetc_cons=fgetc_cons_inkey -pragma-redirect:getk=getk_inkey 
ALIAS   --vt100  -pragma-need=ansiterminal -D__CONIO_VT100 

#
# Math library aliases (classic)
#
ALIAS   --math-mbf32            -Cc-fp-mode=mbf32   -lmbf32@{ZCC_LIBCPU} -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MBF32 -Ca-D__MATH_MBF32 -D__MATH_MBF32
ALIAS   --math-mbf64            -Cc-fp-mode=mbf64   -pragma-define:CLIB_64BIT_FLOATS=1   -lmbf64
ALIAS   --math-bbc              -Cc-fp-mode=z88     -lbbc_math@{ZCC_LIBCPU}
ALIAS   --math-dai32            -Cc-fp-mode=am9511  -ldaimath32@{ZCC_LIBCPU} -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_DAI32 -Ca-D__MATH_DAI32 -D__MATH_DAI32
ALIAS   --math-am9511           -Cc-fp-mode=ieee    -lam9511@{ZCC_LIBCPU} -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_AM9511 -Ca-D__MATH_AM9511 -D__MATH_AM9511
ALIAS   --math-cpc              -Cc-fp-exponent-bias=128 -Cc-fp-mantissa-size=5     -lcpcz80_math -D__MATH_CPC
ALIAS   --fastmath              -lfastmath@{ZCC_LIBCPU}



#
# Math library aliases (classic + newlib)
#
ALIAS   --math16                                    -lmath16 --opt-code-speed=inlineints -Cc-D__MATH_MATH16 -Ca-D__MATH_MATH16 -D__MATH_MATH16
ALIAS   --math32                -Cc-fp-mode=ieee    -lmath32@{ZCC_LIBCPU} -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_MATH32 -Ca-D__MATH_MATH32 -D__MATH_MATH32
ALIAS   --am9511                -Cc-fp-mode=ieee    -lam9511@{ZCC_LIBCPU} -pragma-define:CLIB_32BIT_FLOATS=1 -Cc-D__MATH_AM9511 -Ca-D__MATH_AM9511 -D__MATH_AM9511

