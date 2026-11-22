; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_f_read

EXTERN __esxdos_error_zc

asm_esxdos_f_read:

   ; F_READ:
   ; Read BC bytes at HL off file handle A. On return BC=number of bytes actually read.
   ; File pointer gets updated.
   ;
   ; enter :     a = uchar handle
   ;            bc = size_t nbytes
   ;            hl = void *dst
   ;
   ; exit  : success
   ;
   ;            hl = num bytes read
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
   defb __ESXDOS_SYS_F_READ
   
   ld l,c
   ld h,b
   jp c,__esxdos_error_zc
   ld a,c
   or b
   ret nz
   scf
   ret
