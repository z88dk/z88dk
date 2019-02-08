

        MODULE  __tms9918_cls
	SECTION code_clib
	PUBLIC	__tms9918_cls

        EXTERN  ansi_cls
	EXTERN	__tms9918_screen_mode
        EXTERN  FILVRM


__tms9918_cls:
        ld      a,(__tms9918_screen_mode)
        cp      2
        jr      nz,clear_text
        call    ansi_cls
        ret

clear_text:
        ; Lets just clear the maximum size
        ld      hl,$0000
        ld      bc,960
        ld      a,32
        call    FILVRM
        ret
