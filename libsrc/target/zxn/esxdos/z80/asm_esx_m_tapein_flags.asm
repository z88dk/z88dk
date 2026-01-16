; unsigned char esx_m_tapein_flags(uint8_t flags)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_tapein_flags

EXTERN __esxdos_error_mc

asm_esx_m_tapein_flags:


   ; enter :  l = flags (bit 0 = 1 pause on screen$, bit 1 = 1 simulate tape loading)
   ;
   ; exit  : success
   ;
   ;            hl = previous flags (bit 0=pause on screen$, bit 1=simulate)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   ld b,6
   ld a,l

   rst __ESX_RST_SYS
   defb __ESX_M_TAPEIN

   ld l,a
   ld h,0

   ret nc
   jp __esxdos_error_mc


; ***************************************************************************
; * M_TAPEIN ($8b) *
; ***************************************************************************
; Tape input redirection control.
; Entry:
; B=0, in_open:
; Attach tap file with name at IX, drive in A
; B=1, in_close:
; Detach tap file
; B=2, in_info:
; Return attached filename to buffer at IX and drive in A
; B=3, in_setpos:
; Set position of tape pointer to block DE (0=start)
; B=4, in_getpos:
; Get position of tape pointer, in blocks, to HL
; B=5, in_pause:
; Toggles pause delay when loading SCREEN$
; On exit, A=1 if pause now enabled, A=0 if not
; B=6, in_flags:
; Set tape flags to A
; bit 0: 1=pause delay at SCREEN$ (as set by in_pause)
; bit 1: 1=simulate tape loading with border/sound
