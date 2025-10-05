; unsigned char esx_m_tapeout_open(unsigned char *appendname)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_tapeout_open

PUBLIC __esx_m_tapeout_call
PUBLIC __esx_m_tapeout_call_default_drive

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_esx_m_tapeout_open:

   ; enter : hl = char *appendname
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
	
	ld b,0

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

__esx_m_tapeout_call_default_drive:

   ld a,'*'

__esx_m_tapeout_call:

   rst __ESX_RST_SYS
   defb __ESX_M_TAPEOUT

	jp nc, error_znc
	jp __esxdos_error_mc


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
