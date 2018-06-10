divert(-1)

include(`config_private.inc')

divert

SECTION rodata_env

PUBLIC __ENV_FILE

__ENV_FILE:

   defm "__ENV_FILENAME", 0
