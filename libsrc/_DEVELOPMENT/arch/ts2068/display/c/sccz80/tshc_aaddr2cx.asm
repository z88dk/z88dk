; uchar tshc_aaddr2cx(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2cx

EXTERN zx_saddr2cx

defc tshc_aaddr2cx = zx_saddr2cx
