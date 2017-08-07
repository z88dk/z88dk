; ulong esxdos_f_fgetpos(uchar handle)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_fgetpos

EXTERN __esxdos_error_mc

asm_esxdos_f_fgetpos:

   ; F_FGETPOS:
   ; Get current file pointer. A=handle.
   ; No information on where the file pointer goes, assume BCDE
   ;
   ; enter :    l = file handle
   ;
   ; exit  : success
   ;
   ;            dehl = current file position
   ;            carry reset
   ;
   ;         error
   ;
   ;            dehl = -1
   ;            carry set, errno set
   ;
   ; uses  : unknown
   
   ld a,l
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_FGETPOS
   
   ex de,hl
   ld e,c
   ld d,b
   
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc
