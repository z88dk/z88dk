; 
;	Startup code for the UZI system
;
;	Created 22/1/99
;
;	UZI is completely stand alone so we don't need most
;	of the gunk that OZ offers..

;	We may have more vars later to control memory
;	size etc..




		INCLUDE	"director.def"


		PUBLIC	_start_init


; UZI proper starts at 8192 and runs to 32768
; Processes are loaded at 32768
	
		org	8192

; We enter in with sp pointing to somewhere in the system
; stack...so just store it for use in any (rare) syscalls
; that we make
		ld	(system_stack),sp
		jp	_start_init
; Jump back to quit application (user shutdown)
user_shutdown:
		ld	sp,(system_stack)
		xor	a
		call_oz(os_bye)

;Save a byte here, byte there! This has label because it's used for
;calculated calls etc
l_dcal:
        jp      (hl)

system_stack:
	defw	0

	defm	"UZIz88"
	defb	0
