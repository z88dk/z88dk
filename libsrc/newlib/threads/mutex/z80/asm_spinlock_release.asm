
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_release

.asm_spinlock_release

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;
   ; uses  : none

IF __CPU_INTEL__
   dec (hl)                    ; atomic operation
   ret

ELSE
   ld (hl),$fe                 ; atomic operation
   ret

ENDIF
