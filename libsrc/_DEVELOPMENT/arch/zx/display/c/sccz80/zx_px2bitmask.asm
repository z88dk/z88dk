
; uint zx_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC zx_px2bitmask

EXTERN asm_zx_px2bitmask

defc zx_px2bitmask = asm_zx_px2bitmask
