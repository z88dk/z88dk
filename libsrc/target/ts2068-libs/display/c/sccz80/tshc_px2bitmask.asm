; uchar tshc_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_px2bitmask

EXTERN zx_px2bitmask

defc tshc_px2bitmask = zx_px2bitmask

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_px2bitmask
defc _tshc_px2bitmask = tshc_px2bitmask
ENDIF

