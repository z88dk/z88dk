        SECTION code_fp_mbf64

        PUBLIC  sin
	INCLUDE	"mbf64.def"

        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_SIN
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

sin:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_SIN
        call    msbios
        jp      ___mbf64_return_single
