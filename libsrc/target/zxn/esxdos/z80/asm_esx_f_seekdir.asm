; unsigned char esx_f_seekdir(unsigned char handle,uint32_t pos)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_seekdir

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_seekdir:

   ; enter :    a = handle
   ;         bcde = directory position
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

   rst __ESX_RST_SYS
   defb __ESX_F_SEEKDIR

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_SEEKDIR ($a6) *
; ***************************************************************************
; Set current directory position.
; Entry:
; A=handle
; BCDE=offset in directory to seek to (as returned by F_TELLDIR)
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
   