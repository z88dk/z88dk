
#ifndef _THREADS_H
#define _THREADS_H

#include <stdint.h>

// DATA STRUCTURES

typedef struct mtx_s
{

   uint8_t thrd_owner;
   uint8_t mutex_type;
   uint8_t lock_count;
   
   uint8_t spinlock;
   void   *q;             // p_forward_list *

} mtx_t;

typedef uint16_t       once_flag;
#define ONCE_FLAG_INIT 0x00fe

#ifdef __SDCC

// SDCC

// mutex

extern void   call_once(once_flag *flag, void (*func)(void));
extern void   mtx_destroy(mtx_t *m);
extern int    mtx_init(mtx_t *m, int type);
extern int    mtx_lock(mtx_t *m);
extern int    mtx_timedlock(mtx_t *m, struct timespec *ts);
extern int    mtx_trylock(mtx_t *m);
extern int    mtx_unlock(mtx_t *m);
extern void   spinlock_acquire(char *spinlock);
extern void   spinlock_release(char *spinlock);
extern int    spinlock_tryacquire(char *spinlock);

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern void   mtx_destroy_fastcall(mtx_t *m) __z88dk_fastcall;
extern int    mtx_lock_fastcall(mtx_t *m) __z88dk_fastcall;
extern int    mtx_trylock_fastcall(mtx_t *m) __z88dk_fastcall;
extern int    mtx_unlock_fastcall(mtx_t *m) __z88dk_fastcall;
extern void   spinlock_acquire_fastcall(char *spinlock) __z88dk_fastcall;
extern void   spinlock_release_fastcall(char *spinlock) __z88dk_fastcall;
extern int    spinlock_tryacquire_fastcall(char *spinlock) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define mtx_destroy(a)           mtx_destroy_fastcall(a)
#define mtx_lock(a)              mtx_lock_fastcall(a)
#define mtx_trylock(a)           mtx_trylock_fastcall(a)
#define mtx_unlock(a)            mtx_unlock_fastcall(a)
#define spinlock_acquire(a)      spinlock_acquire_fastcall(a)
#define spinlock_release(a)      spinlock_release_fastcall(a)
#define spinlock_tryacquire(a)   spinlock_tryacquire_fastcall(a)

#endif

#ifndef __SDCC_DISABLE_CALLEE

// SDCC CALLEE LINKAGE

extern void   call_once_callee(once_flag *flag, void *func) __z88dk_callee;
extern int    mtx_init_callee(mtx_t *m, int type) __z88dk_callee;
extern int    mtx_timedlock_callee(mtx_t *m, struct timespec *ts) __z88dk_callee;

// SDCC MAKE CALLEE LINKAGE THE DEFAULT

#define call_once(a,b)              call_once_callee(a,b)
#define mtx_init(a,b)               mtx_init_callee(a,b)
#define mtx_timedlock(a,b)          mtx_timedlock_callee(a,b)

#endif

#else

// SCCZ80

// mutex

extern void   __LIB__               call_once(once_flag *flag, void *func);
extern void   __LIB__ __FASTCALL__  mtx_destroy(mtx_t *m);
extern int    __LIB__               mtx_init(mtx_t *m, int type);
extern int    __LIB__ __FASTCALL__  mtx_lock(mtx_t *m);
extern int    __LIB__               mtx_timedlock(mtx_t *m, struct timespec *ts);
extern int    __LIB__ __FASTCALL__  mtx_trylock(mtx_t *m);
extern int    __LIB__ __FASTCALL__  mtx_unlock(mtx_t *m);
extern void   __LIB__ __FASTCALL__  spinlock_acquire(char *spinlock);
extern void   __LIB__ __FASTCALL__  spinlock_release(char *spinlock);
extern int    __LIB__ __FASTCALL__  spinlock_tryacquire(char *spinlock);

// SCCZ80 CALLEE LINKAGE

// mutex

extern void   __LIB__ __CALLEE__    call_once_callee(once_flag *flag, void *func);
extern int    __LIB__ __CALLEE__    mtx_init_callee(mtx_t *m, int type);
extern int    __LIB__ __CALLEE__    mtx_timedlock_callee(mtx_t *m, struct timespec *ts);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

// mutex

#define call_once(a,b)              call_once_callee(a,b)
#define mtx_init(a,b)               mtx_init_callee(a,b)
#define mtx_timedlock(a,b)          mtx_timedlock_callee(a,b)

#endif

#endif
