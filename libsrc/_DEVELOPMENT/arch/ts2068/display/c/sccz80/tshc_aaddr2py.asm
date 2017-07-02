; uchar tshc_aaddr2py(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2py

EXTERN zx_saddr2py

defc tshc_aaddr2py = zx_saddr2py
