
SECTION data_clib
SECTION data_fcntl

PUBLIC __fcntl_fdtbl_lock

EXTERN mtx_plain

__fcntl_fdtbl_lock:

   defb 0                      ; thrd_owner
   defb mtx_plain              ; mutex type
   defb 0                      ; lock count
   defb $fe                    ; spinlock
   defw 0                      ; forward_list_t
