; void ts_vmod(unsigned char mode)

SECTION code_clib
SECTION code_arch

PUBLIC _ts_vmod_fastcall

EXTERN asm_ts_vmod

defc _ts_vmod_fastcall = asm_ts_vmod
