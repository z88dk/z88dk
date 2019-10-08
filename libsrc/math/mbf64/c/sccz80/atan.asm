        SECTION code_fp_mbf64

        PUBLIC  atan
	INCLUDE	"mbf64.def"

        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_ATN
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

atan:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_ATN
        call    msbios
        jp      ___mbf64_return_single
