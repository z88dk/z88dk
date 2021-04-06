
#ifndef MEMORY_H
#define MEMORY_H

// Functions that page in the specified address space
extern void setb1(void);
extern void setb4(void);

// And the address spaces they correspond to
__addressmod setb1 spaceb1;
__addressmod setb4 spaceb4;

// Put some variables into those address spaces
extern spaceb1 int value_in_b1;
extern spaceb4 int array_in_b4[10];


#endif
