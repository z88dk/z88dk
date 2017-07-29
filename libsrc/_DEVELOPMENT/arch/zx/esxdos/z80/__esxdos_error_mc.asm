INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC __esxdos_error_mc

EXTERN __esxdos_error_translate
EXTERN errno_mc

IF __CLIB_OPT_ERROR

__esxdos_error_mc:

   ; set errno and exit indicatig error
   ;
   ; enter : a = esxdos error code
   ;
   ; exit  : hl = -1, carry set, errno set

   call __esxdos_error_translate
   jp errno_mc

ELSE

defc __esxdos_error_mc = errno_mc - 2

ENDIF
