
SECTION rodata_clib
SECTION rodata_stdio

PUBLIC __stdio_file_list_lock

EXTERN mtx_plain

__stdio_file_list_lock:

   defb 0                      ; thrd_owner
   defb mtx_plain              ; mutex type
   defb 0                      ; lock count
   defb $fe                    ; spinlock
   defw 0                      ; forward_list_t
