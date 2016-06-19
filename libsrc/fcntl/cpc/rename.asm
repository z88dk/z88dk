;
;       CPC fcntl Routines
;       Rename a file
;
;       int rename(char *oldname, char *newname)
;
;       ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
;       source:  http://www.cepece.info/amstrad/source/rsxcall.html
;       ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
;
;       $Id: rename.asm,v 1.5 2016-06-19 21:03:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    rename
        PUBLIC    _rename
        EXTERN	strlen
        EXTERN	cpc_rsx
        EXTERN	bios_msg

        INCLUDE "cpcfirm.def"              

.rename
._rename

        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc

        push	de
        ld	(sdb_new_filename+1),hl
        call	strlen
        ld	a,l
        ld	(sdb_new_filename),a
        
        pop	hl
        ld	(sdb_old_filename+1),hl
        call	strlen
        ld	a,l
        ld	(sdb_old_filename),a

	;ld	hl,255	; msg disable
	;push	hl
	;call	bios_msg
	;pop	hl
	
; |REN,"<new filename>,"<old filename>"

	ld	hl,ren_cmd
	push	hl
	ld	hl,sdb_old_filename
	push	hl
	ld	hl,sdb_new_filename
	push	hl
	ld	a,3	; number of parameters
	call	cpc_rsx
	pop	bc
	pop	bc
	pop	bc

	;ld	hl,0	; msg enable
	;push	hl
	;call	bios_msg
	;pop	hl

	ret

.ren_cmd	defm	"ren",0

;;-------------------------------------------------------------
;; the string descriptor blocks for the parameters

;; string descriptor block for old filename
.sdb_old_filename
defb 0      ;; length of string
defw 0      ;; address of string

;; string descriptor block for new filename
.sdb_new_filename
defb 0      ;; length of string
defw 0      ;; address of string

;;-------------------------------------------------------------

