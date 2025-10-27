; uchar tshc_aaddr2px(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2px

EXTERN _zx_saddr2px

defc _tshc_aaddr2px = _zx_saddr2px
