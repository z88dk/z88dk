        SECTION code_fp_mbf64

        PUBLIC  log
	INCLUDE	"mbf64.def"

        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_LOG
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

log:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_LOG
        call    msbios
        jp      ___mbf64_return_single
