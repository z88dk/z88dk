/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_wait.c,v 1.5 2016-04-25 20:11:47 dom Exp $
 */

#include <threading/semaphore.h>


int sem_wait(sem_t *sem)
{
#asm
	di
	pop     de
	pop     hl
	push    hl
	push    de
	push	ix
	push	hl
	pop	ix
again:
	ld      l,(ix+semaphore_value)
	ld      h,(ix+semaphore_value+1)
	bit     7,h		; Is it negative
	jr      nz,wait_for_semaphore
	ld	a,h
	or	l
	jr	z,wait_for_semaphore
.got_semaphore
	dec     hl
	ld      (ix+semaphore_value),l
	ld      (ix+semaphore_value+1),h
	ei      
	ld      hl,0
	pop	ix
	ret     
.wait_for_semaphore
	push    ix
	ld      ix,(_threadbase + current)	; Get current thread
	set     0,(ix+thread_flags)		; We should sleep
	pop     ix				; Get semaphore back
	ld	a,(ix+semaphore_waiters_num)
	inc	(ix+semaphore_waiters_num)
	ld	l,a
	ld	h,0
	add	hl,hl
	push	ix
	pop	de
	add	hl,de
	ld	de,semaphore_waiters
	add	hl,de
	ld	de,(_threadbase + current)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ei      
.wait_loop
	; Just busy loop - we will be woken up at some point...
	halt
	di
	jr	again
#endasm
}
