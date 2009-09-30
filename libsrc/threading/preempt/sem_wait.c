/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_wait.c,v 1.1 2009-09-30 19:06:07 dom Exp $
 */

#include <threading/semaphore.h>


int sem_wait(sem_t *sem)
{
#asm
	pop     de
	pop     ix
	push    ix
	push    de
	di      
	ld      l,(ix+semaphore_value)
	ld      h,(ix+semaphore_value+1)
	bit     7,h		; Is it negative
	jr      nz,wait_for_semaphore
.got_semaphore
	dec     hl
	ld      (ix+semaphore_value),l
	ld      (ix+semaphore_value+1),h
	ei      
	ld      hl,0
	ret     
.wait_for_semaphore
	push    ix
	ld      ix,(_threadbase + current)	; Get current thread
	set     0,(ix+thread_flags)		; We should sleep
	pop     ix				; Get semaphore back
.wait_loop
	; Just busy loop - we will be woken up at some point...
	ei      
	di      
	ld      l,(ix+semaphore_value)		; Check value
	ld      h,(ix+semaphore_value+1)
	bit     7,h
	jr      z,got_semaphore
	ei      
	jr	wait_loop
#endasm
}
