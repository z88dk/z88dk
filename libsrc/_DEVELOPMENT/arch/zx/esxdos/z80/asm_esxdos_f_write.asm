; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_write

EXTERN __esxdos_error_zc

asm_esxdos_f_write:

   ; F_WRITE:
   ; Write BC bytes from HL off file handle A. On return BC=number of bytes actually written.
   ; File pointer gets updated.
   ;
   ; enter :     a = uchar handle
   ;            bc = size_t nbyte
   ;            hl = void *src
   ;
   ; exit  : success
   ;
   ;            hl = num bytes written
   ;            carry reset
   ;
   ;         error
   ;
   ;            hl = 0
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
   defb __ESXDOS_SYS_F_WRITE
   
   ld l,c
   ld h,b
   ret nc
   
   jp __esxdos_error_zc
