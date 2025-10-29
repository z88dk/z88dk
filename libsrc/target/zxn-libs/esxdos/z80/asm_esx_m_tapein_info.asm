; unsigned char esx_m_tapein_info(uint8_t *drive,unsigned char *filename)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_tapein_info

EXTERN __esxdos_error_mc
EXTERN error_znc

asm_esx_m_tapein_info:

   ; enter : hl = char *filename
   ;         de = uint8_t *drive (0 = does not write)
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
   
   push de
   
   ld b,2
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_M_TAPEIN
   
   pop hl
   
   jp c, __esxdos_error_mc
   
   ld e,a
   
   ld a,h
   or l
   jr z, exit
   
   ld (hl),e

exit:

   jp error_znc


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
