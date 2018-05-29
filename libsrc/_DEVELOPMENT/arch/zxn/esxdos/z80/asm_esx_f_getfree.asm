; uint32_t esx_f_getfree(void)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_getfree

EXTERN __esxdos_error_mc

asm_esx_f_getfree:

   ; enter : none
   ;
   ; exit  : success
   ;
   ;            dehl = number of 512 byte blocks available on default drive
   ;            carry reset
   ;
   ;         fail
   ;
   ;            dehl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   ld a,'*'
   
   rst __ESX_RST_SYS
   defb __ESX_F_GETFREE
   
   ld l,c
   ld h,b
   
   ex de,hl
   
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc


; ***************************************************************************
; * F_GETFREE ($b1) *
; ***************************************************************************
; Gets free space on drive.
; Entry:
; A=drive specifier
; Exit (success):
; Fc=0
; BCDE=number of 512-byte blocks free on drive
; Exit (failure):
; Fc=1
; A=error code
