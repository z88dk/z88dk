
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_sigdigf, asm_dsigdig

EXTERN m32_fssigdig

DEFC asm_sigdigf = m32_fssigdig

DEFC asm_dsigdig = m32_fssigdig
