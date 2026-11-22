; dstore() -- stub that shadows the classic f48 store helper.
;
; The classic scanf %f handler statically references dstore() in its
; 48-bit store branch.  That branch is dead code when 32-bit floats are
; linked (CLIB_32BIT_FLOATS = 1), but the static reference forces the
; f48 dstore -- and with it the 6-byte floatpack (fa / init_floatpack) --
; to be pulled from the classic clib, which breaks the classic --math32
; scanf link.  math32 already shadows the f48 dload/dloadb with 4-byte
; loaders; this stub completes the set so a math32 link does not pull
; the 6-byte floatpack.  It is never reached with 32-bit floats; if it
; were, it would need to copy DEHL to the target address.

SECTION code_clib
SECTION code_fp_math32

PUBLIC dstore

dstore:

   ret
