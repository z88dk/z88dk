        SECTION code_fp_mbf64

        PUBLIC  sqrt
	INCLUDE	"mbf64.def"

        EXTERN  fp_setup_single
        EXTERN  ___mbf32_SQRT
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

sqrt:
        call    fp_setup_single
        ld      ix,___mbf32_SQRT
        call    msbios
        jp      ___mbf64_return_single
