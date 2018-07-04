divert(-1)
include(`config_private.inc')
divert

INCLUDE "config_private.inc"

SECTION rodata_env

PUBLIC __ENV_TMPNAM_TEMPLATE
PUBLIC __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET

__ENV_TMPNAM_TEMPLATE:

   defm "__ENV_TMPDIR/tmpXXXX", 0   ; must be exactly __ENV_LTMPNAM bytes

defc __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET = __ENV_LTMPNAM - 5
