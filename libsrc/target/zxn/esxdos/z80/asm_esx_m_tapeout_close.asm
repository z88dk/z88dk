; unsigned char esx_m_tapeout_close(void)

SECTION code_esxdos

PUBLIC asm_esx_m_tapeout_close

EXTERN __esx_m_tapeout_call

asm_esx_m_tapeout_close:

   ; enter : none
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
	; uses  : af, bc, de, hl
	
	ld b,1
	jp __esx_m_tapeout_call

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
