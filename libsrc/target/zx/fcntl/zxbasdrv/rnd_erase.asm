;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: rnd_erase.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	rnd_erase
	PUBLIC	_rnd_erase
	PUBLIC	rnd_erase_fastcall
	PUBLIC	_rnd_erase_fastcall
	EXTERN	zx_goto
	EXTERN	zxgetfname2

.rnd_erase
._rnd_erase
IF __CPU_GBZ80__
   ld  hl,sp+2
   ld  a,(hl+)
   ld  h,(hl)
   ld  l,a
ELIF __CPU_RABBIT__ | __CPU_KC160__
   ld hl,(sp+2)
ELSE
   pop de
   pop hl
   push hl
   push de
ENDIF


.rnd_erase_fastcall
._rnd_erase_fastcall
	
	call	zxgetfname2
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

