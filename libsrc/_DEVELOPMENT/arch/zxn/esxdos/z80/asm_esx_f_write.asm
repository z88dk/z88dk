; uint16_t esx_f_write(unsigned char handle, void *src, size_t nbytes)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_write

EXTERN __esxdos_error_mc

asm_esx_f_write:

   ; enter :  a = handle
   ;         bc = nbytes
   ;         hl = src
   ;
   ; exit  : hl = number of bytes actually written
   ;
   ;         success
   ;
   ;            carry reset
   ;
   ;         fail
   ;
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_WRITE

   call c, __esxdos_error_mc
   
   ld l,c
   ld h,b
   
   ret


; ***************************************************************************
; * F_WRITE ($9e) *
; ***************************************************************************
; Write bytes to file.
; Entry:
; A=file handle
; IX=address
; BC=bytes to write
; Exit (success):
; Fc=0
; BC=bytes actually written
; Exit (failure):
; Fc=1
; BC=bytes actually written
