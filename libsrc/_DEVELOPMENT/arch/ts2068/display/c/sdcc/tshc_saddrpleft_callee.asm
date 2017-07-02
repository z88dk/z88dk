; void *tshc_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpleft_callee

EXTERN _zx_saddrpleft_callee

defc _tshc_saddrpleft_callee = _zx_saddrpleft_callee
