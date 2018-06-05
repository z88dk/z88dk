; unsigned char esx_f_unlink(unsigned char *filename)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_unlink

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_unlink:

   ; enter :   hl = char *filename
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
   ; uses  : af, bc, de, hl, ix
   
   ld a,'*'
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_UNLINK

   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_UNLINK ($ad) *
; ***************************************************************************
; Delete file.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=filespec, null-terminated
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
