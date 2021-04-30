    SECTION bss_clib

    PUBLIC  SAM_PALETTE_VALUES
    PUBLIC  _SAM_PALETTE_VALUES

; We keep a copy of the palette values, for -subtype=basic this
; is overridden and points to the BASIC system variables
SAM_PALETTE_VALUES:
_SAM_PALETTE_VALUES:
    defs    16
