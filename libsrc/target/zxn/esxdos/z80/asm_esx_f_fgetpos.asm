; uint32_t esx_f_fgetpos(unsigned char handle)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_fgetpos

EXTERN __esxdos_error_mc

asm_esx_f_fgetpos:

   ; enter :  l = handle
   ;
   ; exit  : success
   ;
   ;            dehl = current file pointer
   ;            carry reset
   ;
   ;         fail
   ;
   ;            dehl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   ld a,l
   
   rst __ESX_RST_SYS
   defb __ESX_F_FGETPOS
   
   ld l,c
   ld h,b
   
   ex de,hl
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc


; ***************************************************************************
; * F_FGETPOS ($a0) *
; ***************************************************************************
; Get current file position.
; Entry:
; A=file handle
; Exit (success):
; Fc=0
; BCDE=current position
; Exit (failure):
; Fc=1
; A=error code
