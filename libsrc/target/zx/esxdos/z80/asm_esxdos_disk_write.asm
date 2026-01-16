; int esxdos_disk_write(uchar device, ulong position, void *src)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_disk_write

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_disk_write:

   ; DISK_WRITE:
   ; Write one block of data from device A, at position BCDE at address HL
   ; 
   ; Note:  This may be disk io to a physical position on the disk
   ;        rather than to a specific file.
   ;
   ; enter :     a = uchar device
   ;          bcde = ulong position
   ;            hl = void *src
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
   defb __ESXDOS_SYS_DISK_WRITE
   
   jp nc, error_znc
   jp __esxdos_error_mc
