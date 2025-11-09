; uint16_t esx_m_dosversion(void)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_dosversion

EXTERN error_mc, error_zc

asm_esx_m_dosversion:

   ; enter : none
   ;
   ; exit  : if esxdos
   ;
   ;            hl = -1
   ;            carry set
   ;
   ;         if NextOS in 48k mode
   ;         (only NextOS esxdos api available)
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         if NextOS
   ;
   ;            h = BCD Major Version eg $01 \  NextOS
   ;            l = BCD Minor Version eg $98 /  v1.98
   ;            carry reset
   ;
   ; uses  : af, bc, de, hl

   rst __ESX_RST_SYS
   defb __ESX_M_DOSVERSION

   jp c, error_mc              ; esxdos <= 0.8.6
   
   ld hl,0x4e58                ; 'NX'
   
   sbc hl,bc
   jp nz, error_mc             ; NextOS signature is missing, return esxdos
   
   or a
   jp nz, error_zc             ; NextOS in 48k mode
   
   ex de,hl                    ; hl = NextOS version
   ret


; ***************************************************************************
; * M_DOSVERSION ($88) *
; ***************************************************************************
; Get API version/mode information.
; Entry:
; -
; Exit:
; For esxDOS <= 0.8.6
; Fc=1, error
; A=14 ("no such device")
;
; For NextOS:
; Fc=0, success
; B='N',C='X' (NextOS signature)
; DE=NextOS version in BCD format: D=major, E=minor version number
; eg for NextOS v1.94, DE=$0194
; HL=A=0 if running in NextOS mode (and zero flag is set)
; HL,A<>0 if running in 48K mode (and zero flag is reset)
