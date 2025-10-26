
JUST SOME NOTES, PROBABLY NO GOOD



scheduler provides:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_context_switch

* give up timeslice, thread remains in running state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_sleep(bc = struct timespec *ts)

* block thread for time specified in ts
* if ts == 0, equivalent to __thread_context_switch
* when scheduler wakes, set hl = thrd_error before return
  (if __thread_block_timeout uses sleep queue)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_block(hl = locked_forward_list *q)

* q->spinlock owned, unlock q->spinlock
* block thread on locked_forward_list *q indefinitely
* if scheduler unblocks (not normal, perhaps if thread terminates),
  set hl = thrd_error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_block_timeout(hl = locked_forward_list *q, bc = struct timespec *ts)

* if ts == 0, same as __thread_block

* q->spinlock owned, unlock q->spinlock
* block thread on locked_forward_list *q for max time specified in ts
* if time expires, set hl = thrd_error before return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__thread_unblock(hl = locked_forward_list *q)

* q->spinlock is owned, do not unlock
* unblock thread at front of q, hl unchanged
* set hl of unblocked thread to thrd_success
* carry reset if no waiting thread

