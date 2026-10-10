/* Only literal-only printf calls in the file: they become puts. */
#include <stdio.h>

int main(void)
{
    printf("alpha\n");
    printf("beta ");
    printf("gamma\n");
    return 0;
}
