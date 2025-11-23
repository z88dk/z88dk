; void *tshc_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_py2saddr

EXTERN _zx_py2saddr

defc _tshc_py2saddr = _zx_py2saddr
