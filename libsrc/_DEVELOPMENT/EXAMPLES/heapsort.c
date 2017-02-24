// This example uses the priority_queue data type in the libary to implement a heapsort.

// Each time an item is extracted from the priority queue, the array holding the queue
// shrinks by one and the extracted item is written to the end in a now vacant spot.
// By extracting all items from the priority queue, what is left is a sorted array.

// Non-standard function intrinsic_label() is used below to insert assembly language
// labels that will be defined in the map file.  These are supplied to ticks so that
// ticks can be used to exactly measure execution time.

// zcc +rc2014 -subtype=rom -v -m -SO3 --max-allocs-per-node200000 --c-code-in-asm --list heapsort.c -o heapsort -create-app
// zcc +zx -v -m -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --c-code-in-asm --list heapsort.c -o heapsort -create-app
//
// -subtype=rom    : make uncompressed rom mapped to address 0x0 (see z88dk/lib/config/rc2014.cfg for options this selects)
// -v              : tell us what zcc is up to, -vn for quiet
// -m              : create a map file of symbols ("timer_start" and "timer_end" defined below will appear in there)
// -SO3            : select the aggressive peephole set
// --max-allocs-per-node200000 : optimization level is set very high
// --c-code-in-asm : intersperse C statements in the .lis file
// --list          : generate a .lis file containing asm translation just prior to link step
// -create-app     : generate an intex hex file .ihx as well as .rom/.bin raw binary to be loaded at address 0x0
//                 : the actual compiler output is heapsort_BSS.bin, heapsort_DATA.bin, heapsort_CODE.bin

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <adt/wa_priority_queue.h>
#include <intrinsic.h>

#pragma output CLIB_OPT_PRINTF       = 0x202   // enable %u%s only
#pragma output CLIB_OPT_SCANF        = 0x2     // enable %u only
#pragma output CLIB_MALLOC_HEAP_SIZE = 5000    // specify a 5k heap

wa_priority_queue_t queue;

// greater than compare for ascending order because we want the priority
// queue to extract largest first and write that to the end of the array

int compare(unsigned int *a, unsigned int *b)
{
    return *b - *a;
}

void main(void)
{
    static unsigned int i;
    static unsigned int num;
    static unsigned int *p;
   
    while (1)
    {
        // how many numbers are we sorting
        
        printf("\nHow many values do you want to sort? ");
        scanf("%u", &num);
        
        // get memory to hold the numbers
        
        free(queue.data);
        queue.data = NULL;
        
        if ((num == 0) || ((p = malloc(num*sizeof(*p))) == NULL))
        {
            printf("Can't malloc %u items, try again.\n", num);
            continue;
        }
        
        // fill array with random numbers
        
        for (i=0; i!=num; ++i)
            p[i] = rand();
        
        // print the random numbers generated
        
        printf("\nSORTING SAMPLE OF %u NUMBERS: ", num);
        for (i=0; i!=num; ++i)
            printf("%u%s", p[i], (i != num-1) ? ", " : "\n");

intrinsic_label(timer_start);

        // turn the non-empty random array into a heap
        
        wa_priority_queue_init(&queue, p, num, compare);   // queue contains zero items, max capacity = num
        wa_priority_queue_resize(&queue, num);             // resize to num items, uncovered items in array assumed valid and trigger application of heap property

        // sort items by popping them out of the priority queue max number first
        // the popped item leaves an empty spot at the end of the array where a copy of the popped item is written by the pop function
        
        while (!wa_priority_queue_empty(&queue))
            wa_priority_queue_pop(&queue);

intrinsic_label(timer_stop);

        // print the result out
        
        printf("\nAFTER SORTING: ");
        for (i=0; i!=num; ++i)
            printf("%u%s", p[i], (i != num-1) ? ", " : "\n\n");

    }
}
