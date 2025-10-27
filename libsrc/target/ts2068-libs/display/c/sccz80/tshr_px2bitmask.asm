; uchar tshr_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_px2bitmask

EXTERN zx_px2bitmask

defc tshr_px2bitmask = zx_px2bitmask

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_px2bitmask
defc _tshr_px2bitmask = tshr_px2bitmask
ENDIF

