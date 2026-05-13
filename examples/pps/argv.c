#include <stdio.h>

int main(int argc, char **argv)
{
    int i;

    printf("argc = %d\n", argc);

    for (i = 0; i < argc; ++i) {
        printf("argv[%d] = \"%s\"\n", i, argv[i]);
    }

    if (argc == 1) {
        puts("Run with arguments to check DSS command-line parsing.");
    }

    return 0;
}
