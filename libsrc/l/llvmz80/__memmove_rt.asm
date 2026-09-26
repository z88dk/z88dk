
; ravn/llvm-z80 compiler-rt runtime-direction memmove helper.
;
; The backend cannot always prove the copy direction between two pointers at
; compile time (e.g. the offset between dst/src is only known at runtime).
; In that case Z80LegalizerInfo.cpp lowers llvm.memmove to a call to the
; dedicated internal helper __memmove_rt under the Z80_AllReg calling
; convention -- register args only, no stack frame, nothing callee-saved
; (ravn/llvm-z80#126) -- instead of the full libc `memmove` stack-ABI call.
;
;   clang ABI : Z80_AllReg args in allocation order HL, DE, BC, ... for the
;               three 16-bit params (dst, src, size) -> dst=HL, src=DE,
;               size=BC.  No return value; nothing needs to be restored on
;               exit (all-register CC = fully caller-saved).
;   core ABI  : z88dk's existing asm_memmove (libsrc/string/z80/asm_memmove.asm)
;               takes hl=src, de=dst, bc=n (already overlap-safe: picks
;               LDIR/LDDR by comparing dst vs src) and returns hl=dst,
;               de=one-past-last, bc=0.
;
; clang's HL/DE (dst/src) is the swap of the core's HL/DE (src/dst), so one
; `ex de,hl` before the call converts the arguments; the core's return values
; are unused (void) so nothing further needs undoing.

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_clang

; clang's datalayout prefixes every symbol reference (including the raw
; MachineOperand::CreateES("__memmove_rt") name) with an extra leading `_`,
; so the assembly-visible symbol is ___memmove_rt (three underscores) --
; mirrors ___mulsi3/___divsi3 in the neighboring bridges.
PUBLIC ___memmove_rt
PUBLIC ___z80_memmove_builtin

EXTERN asm_memmove

___memmove_rt:
___z80_memmove_builtin:
   ex de,hl                     ; llvm-z80 dst=HL,src=DE -> core src=HL,dst=DE
   jp asm_memmove                ; tail call; core's return values are unused (void)
