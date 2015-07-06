include(__link__.m4)

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

// mutex

__DPROTO(void,,call_once,once_flag *flag,void *func)
__DPROTO(void..mtx_destroy,mtx_t *m)
__DPROTO(int,,mtx_init,mtx_t *m,int type)
__DPROTO(int,,mtx_lock,mtx_t *m)
__DPROTO(int,,mtx_timedlock,mtx_t *m,struct timespec *ts)
__DPROTO(int,,mtx_trylock,mtx_t *m)
__DPROTO(int,,mtx_unlock,mtx_t *m)
__DPROTO(void,,spinlock_acquire,char *spinlock)
__DPROTO(void,,spinlock_release,char *spinlock)
__DPROTO(int,,spinlock_tryacquire,char *spinlock)

#endif
