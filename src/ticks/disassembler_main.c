#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include "ticks.h"



static void disassemble_loop(int start, int end);

unsigned char *mem;
int  c_cpu = CPU_Z80;


static void usage(char *program)
{
    printf("z88dk disassembler\n\n");
    printf("%s [options] [file]\n\n",program);
    printf("  -o             Address to load code from\n");
    printf("  -s             Address to start disassembling from\n");
    printf("  -e             Address to disassemble to\n");
    printf("  -mz80          Disassemble z80 code\n");
    printf("  -mz180         Disassemble z180 code\n");
    printf("  -mz80-zxn      Disassemble z80 ZXN code\n");
    printf("  -mr2k          Disassemble Rabbit 2000 code\n");
    printf("  -mr3k          Disassemble Rabbit 3000 code\n");
    printf("  -x <file>      Symbol file to read\n");

    exit(1);
}

int main(int argc, char **argv)
{
    char  *program = argv[0];
    char  *filename;
    uint16_t    org = 0;
    uint16_t    start = 0;
    uint16_t    end = 65535;
    int    loaded = 0;

    mem = calloc(1,65536);

    if ( argc == 1 ) {
        usage(program);
    }

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
                } else if ( strcmp(&argv[0][1],"mz180") == 0 ) {
                    c_cpu = CPU_Z180;
                } else if ( strcmp(&argv[0][1],"mr2k") == 0 ) {
                    c_cpu = CPU_R2K;
                } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
                    c_cpu = CPU_R3K;
                } else {
                    printf("Unknown CPU: %s\n",&argv[0][1]);
                }
                break;
            }
        } else {
            FILE *fp = fopen(argv[1],"r");

            if ( fp != NULL ) {
                size_t r = fread(mem + org, sizeof(char), 65536 - start, fp);
                loaded = 1;
                fclose(fp);
                if ( r < end - org ) {
                    end = org + r;
                }
            } else {
                fprintf(stderr, "Cannot load file '%s'\n",argv[1]);
            }
            argc--; argv++;
        }
    }
    if ( loaded ) {
        disassemble_loop(start,end);
    } else {
        usage(program);
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
