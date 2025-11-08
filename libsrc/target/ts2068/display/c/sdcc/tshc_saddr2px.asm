; uchar tshc_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2px

EXTERN _zx_saddr2px

defc _tshc_saddr2px = _zx_saddr2px
