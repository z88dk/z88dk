; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC asm_esx_m_tapeout_trunc

EXTERN __esx_m_tapeout_call_default_drive

asm_esx_m_tapeout_trunc:

   ; enter : hl = char *filename
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

   ld b,3

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   jp __esx_m_tapeout_call_default_drive


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
