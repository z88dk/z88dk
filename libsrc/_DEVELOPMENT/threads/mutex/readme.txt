
=====
MUTEX
=====

An implementation of the C11 mtx_t type.

typedef struct mtx_s
{

   uchar thrd_owner;   // thread id of current mutex owner (0 = none)
   uchar mutex_type;   // combinations of mtx_plain, mtx_recursive, mtx_timed
   uchar lock_count;   // number of lock acquisitions for recursive mutex
   
   uchar spinlock;     // non-blocking spinlock
   forward_list *q;    // list of threads blocked on mutex, must be fwd_list
                       //   because that container has idempotent remove
} mtx_t;

mtx_plain     = $01
mtx_recursive = $02
mtx_timed     = $04
