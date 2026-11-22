/* A printf with arguments is in the file, so the printf engine is linked
 * anyway: the literal-only calls stay printf and no puts is pulled in. */
#include <stdio.h>

int main(void)
{
    int n = 3;
    printf("alpha\n");
    printf("n=%d\n", n);
    printf("gamma\n");
    return 0;
}
