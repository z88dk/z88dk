; _fflush_fastcall — fflush bridge for ravn/llvm-z80 clang.
;
; Classic fflush is __smallc (FILE* off the stack); clang passes the single arg
; in HL (register ABI). Calling the worker directly misreads the stack and
; leaves SP 2 bytes high -> corrupted exit path / boot loop. fflush has no
; fastcall/callee variant to route to, so this wrapper re-pushes the arg in the
; __smallc layout, calls, and cleans up. stdio.h routes here only for __LLVMZ80.
;
; ABI (z80_fastcall): enter HL=fp; exit HL=int result.

SECTION code_l_clang

PUBLIC _fflush_fastcall
PUBLIC fflush_fastcall

EXTERN _fflush

_fflush_fastcall:
fflush_fastcall:
	pop	de		; DE = return address to the clang caller
	push	de		; keep it below the argument for later cleanup
	push	hl		; push fp where the __smallc worker expects it
	call	_fflush		; worker reads fp off the stack; result in HL
	pop	de		; discard the fp we pushed (caller-cleanup)
	ret			; return to clang with HL = result
