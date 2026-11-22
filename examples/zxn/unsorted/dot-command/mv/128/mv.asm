;; these structures are accessed by NextZXOS functions
;; so need to be in memory accessible to NextZXOS
;; in [0x4000,0xbfe0]
;;
;; in an 8k dot program that means space should be
;; allocated via ROM3_BC_SPACE in main memory
;;
;; in a dotn command it just needs to be in the main bank

INCLUDE "config_zxn_private.inc"

SECTION data_user

PUBLIC _catalog
PUBLIC _lfn

_catalog:

   defb 0      ; filter
   defw 0      ; filename
   defw 0      ; dir_handle
   defb 0      ; completed_sz
   defb 2      ; cat_sz (two dos_catalog entries)
   defs 2*13   ; cat[]

_lfn:

   defw _catalog                    ; cat
   defs __ESX_FILENAME_LFN_MAX + 1  ; long filename
   defs 4                           ; time
   defs 4                           ; size
