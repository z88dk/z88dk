; unsigned char esx_f_getcwd(unsigned char *buf)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_getcwd
PUBLIC l_asm_esx_f_getcwd

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_f_getcwd:

   ; enter : hl = buf
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

l_asm_esx_f_getcwd:

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_GETCWD
   
   jp nc, error_znc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_GETCWD ($a8) *
; ***************************************************************************
; Get current working directory.
; Entry:
; A=drive
; IX=buffer for null-terminated path
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code
