
SECTION code_clib
SECTION code_fp_math48

PUBLIC asm_dconst_inf, asm_dconst_pinf, asm_dconst_minf

EXTERN am48_dconst_inf, am48_dconst_pinf, am48_dconst_minf

defc asm_dconst_inf  = am48_dconst_inf
defc asm_dconst_pinf = am48_dconst_pinf
defc asm_dconst_minf = am48_dconst_minf
