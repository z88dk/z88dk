
SECTION code_clib
SECTION code_fp_math48

PUBLIC asm_dpopret, asm_dxpopret

EXTERN am48_dpopret, am48_dxpopret

defc asm_dpopret  = am48_dpopret
defc asm_dxpopret = am48_dxpopret
