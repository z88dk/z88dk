
; int spinlock_tryacquire(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC spinlock_tryacquire

.spinlock_tryacquire

IF __CPU_INTEL__

   scf
   inc (hl)                     ; atomic operation
   jp NZ,acquisition_failed

   ccf                          ; if acquisition succeeded
   ld hl,1
   ret

.acquisition_failed
   dec (hl)
   ld hl,0
   ret

ELSE

   scf
   rr (hl)                     ; atomic operation

   ld hl,1
   ret NC                      ; if acquisition succeeded

   dec l
   ret

ENDIF
