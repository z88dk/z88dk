        SECTION code_fp_mbf64

        PUBLIC  cos
	INCLUDE	"mbf64.def"

        EXTERN  fp_setup_single
        EXTERN  ___mbf32_COS
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

cos:
        call    fp_setup_single
        ld      ix,___mbf32_COS
        call    msbios
        jp      ___mbf64_return_single
