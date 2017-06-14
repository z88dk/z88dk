; uchar tshc_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddr2px

EXTERN zx_saddr2px

defc tshc_saddr2px = zx_saddr2px
