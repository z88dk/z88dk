
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_init(mtx_t *mtx, int type)
;
; Initialize a mutex.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_init

EXTERN thrd_error, thrd_success, l_setmem_hl

.asm_mtx_init

   ; enter : hl = mtx_t *m
   ;          c = mutex_type
   ;
   ; exit  :  c = mutex_type
   ;
   ;         success
   ;
   ;            hl = thrd_success
   ;            carry reset
   ;
   ;         fail (type not supported)
   ;
   ;            hl = thrd_error
   ;            carry set
   ;
   ; uses  : af, hl
      
   ld a,c
   and $f8
   jr NZ, unknown_type
   
   ld a,c
   and $07
   jr Z, unknown_type

   xor a
   call l_setmem_hl - 12       ; zero structure

   dec hl
   dec hl
   dec hl

IF __CPU_INTEL__
   ld (hl),$ff                 ; initialise(m->spinlock)
ELSE
   ld (hl),$fe                 ; initialise(m->spinlock)
ENDIF

   dec hl
   dec hl
   ld (hl),c                   ; m->mutex_type = c

   ld hl,thrd_success
   ret

unknown_type:

   ld hl,thrd_error
   
   scf
   ret
