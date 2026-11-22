; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; File slots for the TI-83 Plus variable API.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION bss_clib

    PUBLIC  ti_files
    PUBLIC  ti_one

ti_files:
    defs    TI_NSLOTS * TI_SLOT

ti_one:
    defb    0

ENDIF
