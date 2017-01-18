
#ifndef THREADING_SEMAPHORE_T
#define THREADING_SEMAPHORE_T

#include <threading/preempt.h>
#include <sys/compiler.h>
#include <sys/types.h>

typedef struct {
    int             value;                 /**< Value of the semaphore */
    u8_t            waiters_num;           /**< Number of waiters */
    int             waiters[MAX_THREADS];  /**< Number of waiting threads */
} sem_t;

#asm
DEFVARS 0
{
    semaphore_value         ds.w 1
    semaphore_waiters_num   ds.b 1
    semaphore_waiters       ds.w MAX_THREADS
}
#endasm

extern int __LIB__ sem_init(sem_t *sempahore, int shared, int value) __smallc;
extern int __LIB__ sem_wait(sem_t *semaphore);
extern int __LIB__ sem_post(sem_t *semaphore);
extern int __LIB__ sem_getvalue(sem_t *semaphore, int *value) __smallc;
extern int __LIB__ sem_destroy(sem_t *semaphore);


#endif
