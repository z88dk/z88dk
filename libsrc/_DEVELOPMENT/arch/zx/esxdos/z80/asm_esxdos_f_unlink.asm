; int esxdos_f_unlink(void *filename)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_unlink

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_f_unlink:

   ; F_UNLINK:
   ; Delete a file
   ; A=drive, HL=pointer to asciiz file/path
   ;
   ; enter :     a = uchar drive
   ;            hl = void *filename
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
   defb __ESXDOS_SYS_F_UNLINK
   
   jp nc, error_znc
   jp __esxdos_error_mc
