#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include "ticks.h"



static void disassemble_loop(int start, int end);

unsigned char *mem;
int  c_cpu = CPU_Z80;


int main(int argc, char **argv)
{
    char  *filename;
    int    org = 0;
    int    start = 0;
    int    end = 65535;
    int    loaded = 0;

    mem = calloc(1,65536);

    while ( argc > 1  ) {
        if( argv[1][0] == '-' && argv[2] ) {
            switch (argc--, argv++[1][1]){
            case 'o':
                org = atoi(argv[1]);
                break;
            case 's':
                start = atoi(argv[1]);
                break;
            case 'e':
                end = atoi(argv[1]);
                break;
            case 'x':
                read_symbol_file(argv[1]);
                break;
            case 'm':
                if ( strcmp(&argv[0][1],"mz80") == 0 ) {
                    c_cpu = CPU_Z80;
                } else if ( strcmp(&argv[0][1],"mz80-zxn") == 0 ) {
                    c_cpu = CPU_Z80_ZXN;
                } else if ( strcmp(&argv[0][1],"mr2k") == 0 ) {
                    c_cpu = CPU_R2K;
                } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
                    c_cpu = CPU_R3K;
                } else {
                    printf("Unknown CPU: %s\n",&argv[0][1]);
                }
                argv--;
                argc++;
                break;
            }
        } else {
            FILE *fp = fopen(argv[1],"r");

            if ( fp != NULL ) {
                fread(mem + org, sizeof(char), 65536 - start, fp);
                loaded = 1;
                fclose(fp);
            }
        }
    }
    if ( loaded ) {
        disassemble_loop(start,end);
    }
    exit(0);
}

static void disassemble_loop(int start, int end)
{
    char   buf[256];

    while ( start < end ) {
        start += disassemble(start, buf, sizeof(buf));
        printf("%s\n",buf);
    }
}


uint8_t get_memory(int pc)
{
    return mem[pc % 65536];
}
