#ifndef MEMORY_H
#define MEMORY_H


typedef enum {
    MEM_TYPE_INST,      // For instructions
    MEM_TYPE_DATA,      // For data
    MEM_TYPE_STACK,     // For stack
    MEM_TYPE_LOGICAL,   // According to mmu
    MEM_TYPE_PHYSICAL,  // According to hardware
} memtype;



#endif