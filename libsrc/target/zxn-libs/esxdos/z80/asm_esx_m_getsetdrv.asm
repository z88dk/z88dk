; unsigned char esx_m_getdrv(void)
; unsigned char esx_m_setdrv(unsigned char drive)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_getdrv
PUBLIC asm_esx_m_setdrv

EXTERN __esxdos_error_mc

asm_esx_m_getdrv:

IF __ZXNEXT

   xor a
   jr join

ELSE

   ld l,0

ENDIF

asm_esx_m_setdrv:

   ; enter :  l = drive
   ;
   ; exit  :  l = default drive
   ;
   ; uses  : af, bc, de, hl
   
   ld a,l

IF __ZXNEXT

   or $01

join:

ENDIF
   
   rst  __ESX_RST_SYS
   defb __ESX_M_GETSETDRV
   
   ld l,a
   ld h,0
   
   ret nc
   jp __esxdos_error_mc


; ***************************************************************************
; * M_GETSETDRV ($89) *
; ***************************************************************************
; Get or set the default drive.
; Entry:
; A=0, get the default drive
; A<>0, set the default drive to A
; bits 7..3=drive letter (0=A...15=P)
; bits 2..0=drive number (0) -- change: set a bit so drive A can be selected
; Exit (success):
; Fc=0
; A=default drive, encoded as:
; bits 7..3=drive letter (0=A...15=P)
; bits 2..0=drive number (0)
; Exit (failure):
; Fc=1
; A=error code
;
; NOTE:
; This call isn't really very useful, as it is not necessary to provide a
; specific drive to calls which need a drive/filename.
; For such calls, you can instead provide:
; A='*' use the default drive
; A='$' use the system drive (C:, where the NEXTOS and BIN directories are)
