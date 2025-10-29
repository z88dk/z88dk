; unsigned char esx_m_setcaps(unsigned char caps)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_setcaps

EXTERN __esxdos_error_mc

asm_esx_m_setcaps:

   ; enter : l = new capabilities
   ;
   ; exit  : success
   ;
   ;            hl = old capabilities
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   ld a,l
   
   rst  __ESX_RST_SYS
   defb __ESX_M_SETCAPS
   
   jp c, __esxdos_error_mc
   
   ld l,e
   ld h,0
   
   ret

; ***************************************************************************
; * M_SETCAPS ($91) *
; ***************************************************************************
; Entry: A=capabilities to set:
; bit 7=1, do not erase new file data in f_truncate/f_ftruncate
; (increases performance of these calls)
; bits 0..6: reserved, must be zero
; Exit: Fc=0, success
; E=previous capabilities
;
; NOTE: This call is only available from NextOS v1.98M+.
; Earlier versions will return with Fc=1 (error) and A=esx_enocmd
; NOTE: You should save the original value of the capabilities which is
; returned in E. After completing the calls you need with your altered
; capabilities, restore the original value by calling M_SETCAPS again
; with the value that was previously returned in E.
; This will ensure that other programs running after you have exited
; will continue to see the original expected behaviour.
