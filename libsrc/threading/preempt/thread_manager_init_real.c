/*
 *  z88dk z80 multi-task library
 *
 *  $Id: thread_manager_init_real.c,v 1.3 2009-09-30 21:32:10 dom Exp $
 */
 
 
#include <string.h>
#include <stdio.h>
#include <threading/preempt.h>
 
void thread_manager_init_real(scheduler_t *scheduler)
{
    memset(threadbase, 0, sizeof(threadbase_t));
#asm
    	pop	de
	pop	hl
	push	hl
	push	de
	ld	(_threadbase + scheduler),hl
	ld	de,6		; Initialise the scheduler
	add	hl,de
	jp	(hl)
#endasm
}
