        SECTION code_fp_mbf64

        PUBLIC  tan
	INCLUDE	"mbf64.def"

        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_TAN
        EXTERN  ___mbf64_return_tangle
        EXTERN  msbios

tan:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_TAN
        call    msbios
        jp      ___mbf64_return_tangle
