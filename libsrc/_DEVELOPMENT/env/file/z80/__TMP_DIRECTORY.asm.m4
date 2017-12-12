include(`config_private.inc')

; Default TMP Directory Name
; the environment may override in TMP variable

SECTION rodata_env

PUBLIC __TMP_DIRECTORY

__TMP_DIRECTORY:

   defm __TEMP_DIRECTORY, 0
