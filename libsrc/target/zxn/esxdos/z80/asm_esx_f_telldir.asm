; uint32_t esx_f_telldir(unsigned char handle)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_telldir

EXTERN __esxdos_error_mc

asm_esx_f_telldir:

   ; enter :  l = handle
   ;
   ; exit  : success
   ;
   ;            dehl = pointer in directory
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
   defb __ESX_F_TELLDIR
   
   ld l,c
   ld h,b
   
   ex de,hl
   ret nc
   
   ld de,-1
   jp __esxdos_error_mc


; ***************************************************************************
; * F_TELLDIR ($a5) *
; ***************************************************************************
; Get current directory position.
; Entry:
; A=handle
; Exit (success):
; BCDE=current offset in directory
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
