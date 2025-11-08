INCLUDE "config_private.inc"

SECTION bss_env

PUBLIC __ENV_TMPNAM

__ENV_TMPNAM:

   defs __ENV_LTMPNAM

; The implementation shall behave as if no function defined in this
; volume of IEEE Std 1003.1-2001, except tempnam(), calls tmpnam().
