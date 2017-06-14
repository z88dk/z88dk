; uchar tshc_aaddr2cy(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2cy

EXTERN zx_saddr2cy

defc tshc_aaddr2cy = zx_saddr2cy
