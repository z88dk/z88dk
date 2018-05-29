; uint16_t esx_m_execcmd(unsigned char *cmdline)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_execcmd

EXTERN error_znc

asm_esx_m_execcmd:

   ; enter : hl = char *cmdline
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = error for "asm_esx_m_geterr"
   ;            carry set
   ;
   ; uses   : af, bc, de, hl, ix
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_M_EXECCMD
   
   jp nc, error_znc
   
   or a
   scf
   
   ret z
   
   ld l,a
   ld h,0
   
   ret

; ***************************************************************************
; * M_EXECCMD ($8f) *
; ***************************************************************************
; Execute a dot command.
; Entry:
; IX=address of commandline, excluding the leading "."
; terminated with $00 (or $0d, or ':')
; Exit (success):
; Fc=0
; Exit (failure):
; Fc=1
; A=error code (0 means user-defined error)
; HL=address of user-defined error message within dot command
;
; NOTES:
; The dot command name can be fully-pathed if desired. If just a name is
; provided, it is opened from the C:/BIN directory.
; eg: defm "hexdump afile.txt",0 ; runs c:/bin/hexdump
; defm "./mycommand.dot afile.txt",0 ; runs mycommand.dot in current
; ; directory
; If A=0, the dot command has provided its own error message but this is not
; normally accessible. It can be read using the M_GETERR hook.
; This hook cannot be used from within another dot command.
