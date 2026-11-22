; int esxdos_f_close(uchar handle)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_close

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_f_close:

   ; F_CLOSE:
   ; Close a file or dir handle. A=handle.
   ;
   ; enter :  l = file or dir handle
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
   defb __ESXDOS_SYS_F_CLOSE
   
   jp nc, error_znc
   jp __esxdos_error_mc
