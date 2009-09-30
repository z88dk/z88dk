
#include <string.h>
#include <stdio.h>
#include <im2.h>
#include <stdlib.h>
#include <threading/preempt.h>
#include <threading/semaphore.h>


threadbase_t   threadbase;              // Global threadbase
sem_t sem;


void thread1()
{
    while(1) {
	sem_wait(&sem);
        printf("thread 1  ");
	sem_post(&sem);
    }
    /* A thread mustn't exit! or thread_exit() must be called beforehand */
}

void thread2()
{
    while(1) {
#asm
	ld	a,r
	out	(254),a
#endasm
	sem_wait(&sem);
        printf("thread 2 ");
	sem_post(&sem);
    }
    /* A thread mustn't exit! or thread_exit() must be called beforehand */
}

int main()
{

    /* Disable interrupts to start off with */
   sem_init(&sem,0,1);
#asm
   di
#endasm
   printf("Setting im2\n"); 
   im2_Init(0xd300);                // place z80 in im2 mode with interrupt vector table located at 0xd300
   memset(0xd300, 0xd4, 257);       // initialize 257-byte im2 vector table with all 0xd4 bytes
   bpoke(0xd4d4, 195);              // POKE jump instruction at address 0xd4d4 (interrupt service routine entry)
   wpoke(0xd4d5, thread_manager);   // POKE isr address following the jump instruction
 
   printf("Manager init\n"); 
   thread_manager_init(roundrobin_scheduler(4));
   printf("Manager start\n");
   thread_manager_start();          // Create the main thread, this will start the manager up and enable interrupts
 
   // From here we'll be running in multi-task mode
 
   // Now we can add threads */
   printf("Create thread\n"); 
   thread_create(thread1,65000,1);
   while ( 1) {
	sem_wait(&sem);
        printf("main thread ");
	sem_post(&sem);
   }

}
