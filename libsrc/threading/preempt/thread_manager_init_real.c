/*
 *  z88dk z80 multi-task library
 *
 *  $Id: thread_manager_init_real.c,v 1.2 2009-09-29 22:20:22 dom Exp $
 */
 
 
#include <string.h>
#include <stdio.h>
#include <threading/preempt.h>
 
void thread_manager_init_real(scheduler_t *scheduler)
{
    memset(threadbase, 0, sizeof(threadbase_t));
    threadbase->scheduler = scheduler;
    scheduler->scheduler_init();
}
