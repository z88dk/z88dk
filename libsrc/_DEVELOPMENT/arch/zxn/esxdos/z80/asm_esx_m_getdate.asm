; unsigned char esx_m_getdate(struct dos_tm *)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_getdate

EXTERN error_mc, error_znc

asm_esx_m_getdate:

   ; enter : hl = struct dos_tm *
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   push hl
   
   rst __ESX_RST_SYS
   defb __ESX_M_GETDATE

   pop hl
   jp c, error_mc
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   
   jp error_znc


; ***************************************************************************
; * M_GETDATE ($8e) *
; ***************************************************************************
; Get the current date/time.
; Entry:
; -
; Exit:
; Fc=0 if RTC present and providing valid date/time, and:
; BC=date, in MS-DOS format
; DE=time, in MS-DOS format
; Fc=1 if no RTC, or invalid date/time, and:
; BC=0
; DE=0
