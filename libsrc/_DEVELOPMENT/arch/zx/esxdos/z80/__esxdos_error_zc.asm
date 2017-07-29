INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC __esxdos_error_zc

EXTERN __esxdos_error_translate
EXTERN errno_zc

IF __CLIB_OPT_ERROR

__esxdos_error_zc:

   ; set errno and exit indicatig error
   ;
   ; enter : a = esxdos error code
   ;
   ; exit  : hl = 0, carry set, errno set

   call __esxdos_error_translate
   jp errno_zc

ELSE

defc __esxdos_error_zc = errno_zc - 2

ENDIF
