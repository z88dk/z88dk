
; == crt_cfg ==================================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; segment options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; define the segment addresses if you want the segments to
; be separate from the binary and located at a specific location

; the bss segment is always zeroed by the crt at startup

defc __crt_segment_bss_address = 0

; the data segment is initialized according to the next option

defc __crt_segment_data_address = 0

; specify how the data segment is initialized by the crt

defc __crt_cfg_segment_data = 0

; bit 0 = $01 = data segment is initialized from a stored copy
;               if this bit is zero, the data segment is not 
;               initialized and there is no copy.
;
; bit 1 = $02 = compress the stored copy of the data segment
;               (applies only if bit 0 is set)
;               note: not currently implemented

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; exit stack size options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set to zero if you don't want an exit stack
; comment out to get the C standard's requirement of 32

defc __crt_cfg_exit_stack_size      = 4
defc __crt_cfg_quickexit_stack_size = 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; balloc's queue table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set to zero if you don't want a queue table

; your program can still supply a queue table but it must
; supply a word "__qtbl" to hold a pointer to the table.

defc __crt_cfg_qtbl_size = 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; malloc's heap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set to zero if you don't want a heap

; your program can still supply a heap but it must declare
; a word "__heap" to hold a pointer to the heap block.

defc __crt_cfg_heap_size = 2048

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdio FILE structs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set to zero if you don't want any spare FILE structs

; the actual number of FILE structs is three less than this
; number because stdin, stdout, stderr count as three

defc __crt_cfg_fopen_max = 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; host
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; supply the address of the host's system() function
; set to zero to return an error

defc __crt_cfg_system_address = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; locale
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; supply the address of locale functions
; set to zero for defaults

defc __crt_cfg_lc_char_ordinal_address = 0
defc __crt_cfg_lc_char_cmp_bc_address = 0

; =============================================================
