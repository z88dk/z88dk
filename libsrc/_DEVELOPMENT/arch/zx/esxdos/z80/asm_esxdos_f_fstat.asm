; int esxdos_f_fstat(uchar handle, void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_fstat

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_f_fstat:

   ; F_FSTAT:
   ; Get file info/status to buffer at HL. A=handle.
   ;
   ; Buffer format:
   ;
   ; <byte>  drive
   ; <byte>  device
   ; <byte>  file attributes (like MSDOS)
   ; <dword> date
   ; <dword> file size
   ;
   ; enter :     a = uchar handle
   ;         ix/hl = void *buf
   ;
   ; note  : hl is the parameter for dot commands and ix is used otherwise
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

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_FSTAT
   
   jp nc, error_znc
   jp __esxdos_error_mc
