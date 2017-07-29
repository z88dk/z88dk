INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC __esxdos_error_translate

IF __CLIB_OPT_ERROR

__esxdos_error_translate:

   ; translate esxdos error code to library error code
   ;
   ; enter : a = esxdos error code (1-based)
   ; 
   ; exit  : l = library error code

   ld l,$ff

   cp table_end - table
   ret nc            ; if error code is past table, return $ff
   
   add a,table%256
   ld l,a
   adc a,table/256
   sub l
   ld h,a
   
   ld l,(hl)
   ret

table:

   defb __EOK        ; not returned by esxdos
   defb __EOK        ; __ESXDOS_EOK
   defb $ff          ; __ESXDOS_ENONSENSE
   defb $ff          ; __ESXDOS_ESTEND
   defb $ff          ; __ESXDOS_EWRTYPE
   defb $ff          ; __ESXDOS_ENOENT
   defb $ff          ; __ESXDOS_EIO
   defb __EINVAL     ; __ESXDOS_EINVAL
   defb __EACCES     ; __ESXDOS_EACCES
   defb $ff          ; __ESXDOS_ENOSPC
   defb $ff          ; __ESXDOS_ENXIO
   defb $ff          ; __ESXDOS_ENODRV
   defb __ENFILE     ; __ESXDOS_ENFILE
   defb __EBADF      ; __ESXDOS_EBADF
   defb $ff          ; __ESXDOS_ENODEV
   defb __EOVERFLOW  ; __ESXDOS_EOVERFLOW
   defb $ff          ; __ESXDOS_EISDIR
   defb $ff          ; __ESXDOS_ENOTDIR
   defb $ff          ; __ESXDOS_EEXIST
   defb $ff          ; __ESXDOS_EPATH
   defb $ff          ; __ESXDOS_ENOSYS
   defb $ff          ; __ESXDOS_ENAMETOOLONG
   defb $ff          ; __ESXDOS_ENOCMD
   defb $ff          ; __ESXDOS_EINUSE
   defb $ff          ; __ESXDOS_ERDONLY

table_end:

ELSE

   ld l,0
   
   cp __ESXDOS_EOK + 1
   ret c             ; return OK if a <= __ESXDOS_EOK
   
   dec l             ; else return unknown error
   ret

ENDIF
