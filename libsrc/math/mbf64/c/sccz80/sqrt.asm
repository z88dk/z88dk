        SECTION code_fp_mbf64

        PUBLIC  sqrt
	INCLUDE	"mbf64.def"

        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_SQR
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

sqrt:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_SQR
        call    msbios
        jp      ___mbf64_return_single
