; uint16_t esx_f_read(unsigned char handle, void *dst, size_t nbytes)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_read

EXTERN __esxdos_error_mc

asm_esx_f_read:

   ; enter :  a = handle
   ;         bc = nbytes
   ;         hl = dst
   ;
   ; exit  : hl = number of bytes actually read
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
   defb __ESX_F_READ

   call c, __esxdos_error_mc
   
   ld l,c
   ld h,b
   
   ret


; ***************************************************************************
; * F_READ ($9d) *
; ***************************************************************************
; Read bytes from file.
; Entry:
; A=file handle
; IX=address
; BC=bytes to read
; Exit (success):
; Fc=0
; BC=bytes actually read (also in DE)
; HL=address following bytes read
; Exit (failure):
; Fc=1
; BC=bytes actually read
; A=error code
;
; NOTES:
; EOF is not an error, check BC to determine if all bytes requested were read.
