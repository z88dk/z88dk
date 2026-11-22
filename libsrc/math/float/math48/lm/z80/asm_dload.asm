
SECTION code_clib
SECTION code_fp_math48

PUBLIC asm_dload, asm_dloadb

EXTERN am48_dload, am48_dloadb

defc asm_dload  = am48_dload
defc asm_dloadb = am48_dloadb
