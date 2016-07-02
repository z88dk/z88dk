
MODULE __cons_state
SECTION bss_clib

PUBLIC __cons_state

__cons_state:

   defb 0                      ; state var for console editing in gets() and fgets_cons()
                               ; non-zero = capslock on
