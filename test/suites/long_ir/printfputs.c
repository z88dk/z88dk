/* printf/puts calls with a literal and no conversion: puts when the text ends
 * in a newline, adjacent ones merged, anything else left alone. The output is
 * compared with printfputs.expect.
 */
#include <stdio.h>

static const char *shared = "shared\n";

static void tail_label(int n)
{
    printf("a ");
    if (n) printf("then\n");
    printf("b");
    printf(" c\n");
}

int main(void)
{
    int n;
    printf("one\n");
    printf("two ");
    printf("three\n");
    printf("\n");
    printf("val %d\n", 3);
    printf("x\n");
    puts("y");
    printf("z");
    printf("\n");
    printf("same\n");
    printf("same\n");
    printf("pct 100%%\n");
    printf("p");
    printf("%s", shared);
    printf("q\n");
    n = printf("ret\n");
    printf("n=%d\n", n);
    tail_label(0);
    tail_label(1);
    for (n = 0; n < 2; n++) {
        printf("loop ");
        printf("body\n");
    }
    printf("embedded\nnewline\n");
    printf("end");
    printf("\n");
    return 0;
}
