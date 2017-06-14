; uchar tshc_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddr2cx

EXTERN zx_saddr2cx

defc tshc_saddr2cx = zx_saddr2cx
