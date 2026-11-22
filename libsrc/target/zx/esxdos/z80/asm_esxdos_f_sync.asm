; int esxdos_f_sync(uchar handle)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_sync

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_f_sync:

   ; F_SYNC:
   ; For files that have been written to, syncs the file dir entry
   ; (will also flush write cache in future). A=handle.
   ;
   ; enter :  l = uchar handle
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         error
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : unknown
   
   ld a,l
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_SYNC
   
   jp nc, error_znc
   jp __esxdos_error_mc
