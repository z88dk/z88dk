; int esxdos_disk_info(uchar device, void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_disk_info

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_disk_info:

   ; DISK_INFO:
   ;
   ; If A==0 -> Get a buffer at address HL filled with a list of available block devices.
   ; If A!=0 -> Get info for a specific device.
   ;
   ; Buffer format:
   ;
   ; <byte>  Device Path (see below)
   ; <byte>  Device Flags (to be documented, block size, etc)
   ; <dword> Device size in blocks
   ;
   ; The buffer is over when you read a Device Path and you get a 0.
   ; FIXME: Make so that on return A=# of devs
   ;
   ; Device Entry Description
   ;
   ; [BYTE] DEVICE PATH
   ;
   ; ---------------------------------
   ; |       MAJOR       |  MINOR    |
   ; +-------------------------------+
   ; | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
   ; +---+---+---+---+---+---+---+---+
   ; | E | D | C | B   B | A   A   A |
   ;
   ; A: MINOR
   ; --------
   ; 000 : RAW (whole device)
   ; 001 : 0       (first partition/session)
   ; 010 : 1       (second partition/session)
   ; 011 : 2       (etc...)
   ; 100 : 3
   ; 101 : 4
   ; 110 : 5
   ; 111 : 6
   ;
   ; B:
   ; --
   ; 00 : RESERVED
   ; 01 : IDE
   ; 10 : FLOPPY
   ; 11 : VIRTUAL
   ;
   ; C:
   ; --
   ; 0 : PRIMARY
   ; 1 : SECONDARY
   ;
   ; D:
   ; --
   ; 0 : MASTER
   ; 1 : SLAVE
   ;
   ; E:
   ; --
   ; 0 : ATA
   ; 1 : ATAPI
   ;
   ; This needs changing/fixing for virtual devs, etc.
   ; 
   ; enter :     a = uchar device, 0 = get list of available devices
   ;            hl = void *destination buffer
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
   defb __ESXDOS_SYS_DISK_INFO
   
   jp nc, error_znc
   jp __esxdos_error_mc
