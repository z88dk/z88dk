; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddrpleft_callee

EXTERN _zx_saddrpleft_callee

defc _tshc_aaddrpleft_callee = _zx_saddrpleft_callee
