/*
 *  z88dk z80 multi-task library
 *
 *  $Id: thread_manager_init_real.c,v 1.1 2009-09-29 21:39:37 dom Exp $
 */
 
 
#include <string.h>
#include <stdio.h>
#include <threading/preempt.h>
 
void thread_manager_init_real(int max_threads, scheduler_t *scheduler)
{
//    memset(threadbase, 0, sizeof(threadbase_t) - 1 + max_threads * sizeof(thread_t));
    threadbase->max_threads = max_threads;
    threadbase->scheduler = scheduler;
    threadbase->last_pid = 1;
    printf("init scheduler\n");
    scheduler->scheduler_init();
}
