SECTION code_clib
SECTION code_esxdos

PUBLIC __esxdos_error_zc

EXTERN errno_zc

__esxdos_error_zc:

   ; set errno and exit indicatig error
   ;
   ; enter : a = esxdos error code
   ;
   ; exit  : hl = 0, carry set, errno = esxdos code

   ld l,a
   jp errno_zc
