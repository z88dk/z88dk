/*
 *  z88dk z80 multi-task library
 *
 *  $Id: roundrobin_scheduler.c,v 1.5 2015-01-21 17:49:59 stefano Exp $
 *
 *  A simple roundrobin scheduler
 */

#include <threading/preempt.h>

scheduler_t *roundrobin_scheduler(int ticks)
{
#asm
	ld	hl,2
	add	hl,sp
	call	l_gint
	ld	(_threadbase + schedule_data),a	; Store tick count
	ld	hl,roundrobin
#endasm
}

     
#asm

	EXTERN	get_task

; Jump table for the roundrobin scheduler
.roundrobin
        jp      roundrobin_task_schedule
        jp      roundrobin_task_init
        jp      roundrobin_schedule_init
        
        
; Initialise threadbase for the roundrobin scheduler
.roundrobin_schedule_init
	ld	a,(_threadbase + schedule_data)
	and	a
	jr	nz, roundrobin_slice_setup
	ld	a,2		; Default timeslice interval
	ld	(_threadbase + schedule_data),a
.roundrobin_slice_setup
	ld	a,1
	ld	(_threadbase + schedule_data + 1),a
	xor	a
	ld	(_threadbase + schedule_data + 2),a
        ret

; Initialise a roundrobin task
;
; Entry:        ix = task
;                a = task number
.roundrobin_task_init
        ret




; Entry:        ix = current task
; Exit:         ix = new task to run        
.roundrobin_task_schedule
	; Check to see if we have reached the right number of ticks before swapping
	; out
	ld	hl,_threadbase + schedule_data + 1
	dec	(hl)
	ret	nz
	ld	a,(_threadbase + schedule_data)
	ld	(hl),a

	; Now we can select the next task to run
        ld      a,(_threadbase + schedule_data + 2)
        ld      c,a
.roundrobin_loop
        inc     a
        and     MAX_THREADS - 1
        cp      c
        jp      z,roundrobin_noneready          ; We have looped round, nothing ready to run
        call    get_task                        ; Get the task table for the thread
        bit     7,(ix + thread_flags)	        ; No task there
        jr      z,roundrobin_loop
        bit     0,(ix + thread_flags)           ; Check if sleeping
        jr      nz,roundrobin_loop               ; It was sleeping
	ld	(_threadbase + schedule_data + 2),a ; Store our last selected task
        ret                                     ; Exit with a ready task
.roundrobin_noneready
        xor     a                             ; Task zero is the standard task i.e. main() so runs whenever
        call    get_task
        ret
#endasm
        
