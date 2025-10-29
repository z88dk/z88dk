/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_init.c,v 1.1 2009-09-30 19:06:07 dom Exp $
 */

#include <threading/semaphore.h>


int sem_init(sem_t *sem, int shared, int value)
{
    sem->value = value;
    sem->waiters_num = 0;
    return 0;
}
