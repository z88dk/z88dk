; int esxdos_disk_read(uchar device, ulong position, void *dst)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_disk_read

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_disk_read:

   ; DISK_READ:
   ; Read one block of data from device A, at position BCDE at address HL
   ; 
   ; Note:  This may be disk io from a physical position on the disk
   ;        rather than from a specific file.
   ;
   ; enter :     a = uchar device
   ;          bcde = ulong position
   ;            hl = void *dst
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

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_DISK_READ
   
   jp nc, error_znc
   jp __esxdos_error_mc
