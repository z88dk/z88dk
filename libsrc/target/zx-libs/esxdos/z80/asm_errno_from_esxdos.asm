; uchar errno_from_esxdos(uchar code)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_errno_from_esxdos

asm_errno_from_esxdos:

   ; translate esxdos error code to errno error code
   ;
   ; enter : l = esxdos error code
   ; 
   ; exit  : l = errno error code

IF __CLIB_OPT_ERROR

   ld a,l
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
   defb __EIO        ; __ESXDOS_EIO
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
   defb $ff          ; __ESXDOS_EVERIFY
   defb $ff          ; __ESXDOS_ELOADINGKO
   defb $ff          ; __ESXDOS_EDIRINUSE
   defb $ff          ; __ESXDOS_EMAPRAMACTIVE
   defb $ff          ; __ESXDOS_EDRIVEBUSY
   defb $ff          ; __ESXDOS_EFSUNKNOWN
   defb $ff          ; __ESXDOS_EDEVICEBUSY

table_end:

ELSE

   ld a,l
   ld l,0
   
   cp __ESXDOS_EOK + 1
   ret c             ; return OK if a <= __ESXDOS_EOK
   
   dec l             ; else return unknown error
   ret

ENDIF
