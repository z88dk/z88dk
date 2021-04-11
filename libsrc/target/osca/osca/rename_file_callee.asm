;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file_callee.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "target/osca/def/flos.def"

    SECTION code_clib
    PUBLIC  rename_file_callee
    PUBLIC  _rename_file_callee
    EXTERN   flos_err
    PUBLIC  asm_rename_file

rename_file_callee:
_rename_file_callee:
	pop bc
	pop de
	pop hl
	push bc

asm_rename_file:
	call	kjt_rename_file
	jp   flos_err

