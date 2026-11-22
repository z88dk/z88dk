; ulong esxdos_m_getdate(void)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_m_getdate

asm_esxdos_m_getdate:

   ; M_GETDATE:
   ;
   ; Get current date/time in MSDOS format (without the 5th byte,
   ; so it's only 4 bytes - only 2 secs precision).
   ; On DivIDE it's always 23/04/1982 00:00:00
   ;
   ; There's no information on how the date is returned so
   ; the guess is in BCDE for a 4-byte value.
   ;
   ; enter : none
   ;
   ; exit  : dehl = four byte msdos date
   ;
   ; uses  : unknown
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_M_GETDATE
   
   ex de,hl
   ld e,c
   ld d,b
   
   ret
