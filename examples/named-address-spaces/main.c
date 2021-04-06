
#include <stdio.h>

#include "memory.h"


int main() {
    int i;
    printf("Value in address space 1 is %d\n", value_in_b1);
 
    for ( i = 0; i < 10; i++ ) {
        printf("Array in address space 1, [%d] = %d\n",i, array_in_b1[i]);
    }
    printf("String is <%s>\n",string_in_b4);
}
