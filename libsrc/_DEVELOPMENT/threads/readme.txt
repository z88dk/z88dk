
scheduler provides:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_context_switch

* give up timeslice, thread remains in running state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_sleep(bc = struct timespec *ts)

* block thread for time specified in ts
* if ts == 0, equivalent to __thread_context_switch
* if scheduler wakes, set hl = thrd_error before return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_block(de = locked_forward_list *q)

* q->spinlock owned, unlock q->spinlock
* block thread on locked_forward_list *q indefinitely
* if scheduler unblocks (not normal, perhaps if thread terminates),
  set hl = thrd_error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_block_timeout(de = locked_forward_list *q, bc = struct timespec *ts)

* q->spinlock owned, unlock q->spinlock
* block thread on locked_forward_list *q for max time specified in ts
* if ts == 0, equivalent to __thread_context_switch
* if time expires, set hl = thrd_error before return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_unblock(hl = locked_forward_list *q)

* q->spinlock is owned, do not unlock
* unblock thread at front of q, return thread's id in A (0 if none), hl unchanged
