; unsigned char esx_f_rewinddir(unsigned char handle)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_rewinddir

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_rewinddir:

   ; enter :  l = handle
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   ld a,l
   
   rst __ESX_RST_SYS
   defb __ESX_F_REWINDDIR
   
   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_REWINDDIR ($a7) *
; ***************************************************************************
; Rewind directory position to the start of the directory.
; Entry:
; A=handle
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
