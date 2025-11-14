; int esxdos_f_getcwd(void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_getcwd

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esxdos_f_getcwd:

   ; F_GETCWD:
   ; Get current directory path (null-terminated) to a buffer.
   ; A=drive, HL=pointer to buffer
   ;
   ; enter :     a = uchar drive
   ;            hl = void *buf
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
   defb __ESXDOS_SYS_F_GETCWD
   
   jp nc, error_znc
   jp __esxdos_error_mc
