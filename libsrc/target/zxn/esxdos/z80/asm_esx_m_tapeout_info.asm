; unsigned char esx_m_tapeout_info(uint8_t *drive,unsigned char *filename)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_tapeout_info

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_m_tapeout_info:

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
   defb __ESX_M_TAPEOUT
   
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
; * M_TAPEOUT ($8c) *
; ***************************************************************************
; Tape output redirection control.
; Entry:
; B=0, out_open:
; Create/attach tap file with name at IX for appending, drive A
; B=1, out_close:
; Detach tap file
; B=2, out_info:
; Return attached filename to buffer at IX and drive in A
; B=3, out_trunc:
; Create/overwrite tap file with name at IX, drive A
