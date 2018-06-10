divert(-1)

include(`config_private.inc')

divert

SECTION rodata_env

PUBLIC __TMP_DIR

__TMP_DIR:

   defm "__ENV_TMPDIR", 0
