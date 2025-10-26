IF PORTABLE_CPC_MATH

    SECTION code_fp

    PUBLIC CPCFP_FLO_ATAN
    PUBLIC CPCFP_FLO_COS
    PUBLIC CPCFP_FLO_ADD
    PUBLIC CPCFP_FLO_DIV
    PUBLIC CPCFP_FLO_DEG_RAD
    PUBLIC CPCFP_FLO_CMP
    PUBLIC CPCFP_FLO_MUL
    PUBLIC CPCFP_FLO_CMP
    PUBLIC CPCFP_FLO_REV_SUB
    PUBLIC CPCFP_FLO_EXP
    PUBLIC CPCFP_BIN_2_FLO
    PUBLIC CPCFP_FLO_RND
    PUBLIC CPCFP_FLO_BINFIX2
    PUBLIC CPCFP_FLO_LOG
    PUBLIC CPCFP_FLO_LOG10
    PUBLIC CPCFP_FLO_INV_SGN
    PUBLIC CPCFP_FLO_POW
    PUBLIC CPCFP_FLO_SIN
    PUBLIC CPCFP_FLO_SQRT
    PUBLIC CPCFP_FLO_TAN

    defc CPCFP_FLO_ATAN = REAL_arctan
    defc CPCFP_FLO_COS  = REAL_cosine
    defc CPCFP_FLO_ADD  = REAL_addition
    defc CPCFP_FLO_DIV  = REAL_division
    defc CPCFP_FLO_DEG_RAD = REAL_set_degrees_or_radians
    defc CPCFP_FLO_CMP  = REAL_compare
    defc CPCFP_FLO_MUL  = REAL_multiplication
    defc CPCFP_FLO_REV_SUB = REAL_reverse_subtract
    defc CPCFP_FLO_EXP  = REAL_exp
    defc CPCFP_BIN_2_FLO = REAL_BIN_to_real
    defc CPCFP_FLO_RND = REAL_rnd
    defc CPCFP_FLO_BINFIX2 = REAL_fix
    defc CPCFP_FLO_LOG = REAL_log
    defc CPCFP_FLO_LOG10 = REAL_log10
    defc CPCFP_FLO_INV_SGN = REAL_Negate
    defc CPCFP_FLO_POW  = REAL_power
    defc CPCFP_FLO_SIN  = REAL_sin
    defc CPCFP_FLO_SQRT = REAL_sqr
    defc CPCFP_FLO_TAN  = REAL_tan



    INCLUDE "z80/FPMaths.inc"


    SECTION bss_fp


C6_last_random_number:  defs    2
last_random_number:     defs    2
internal_REAL_store_1:  defs    5
internal_REAL_store_2:  defs    5
internal_REAL_store_3:  defs    5
DEG__RAD_flag_:         defb    1

ENDIF

 


