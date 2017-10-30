; void ts_vmod(unsigned char mode)

SECTION code_clib
SECTION code_arch

PUBLIC ts_vmod

EXTERN asm_ts_vmod

defc ts_vmod = asm_ts_vmod
