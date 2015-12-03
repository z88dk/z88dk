
; uint zx_px2bitmask_fastcall(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_px2bitmask_fastcall

EXTERN asm_zx_px2bitmask

defc _zx_px2bitmask_fastcall = asm_zx_px2bitmask
