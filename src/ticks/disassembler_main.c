#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include <limits.h>
#include "disassembler.h"
#include "syms.h"
#include "cpu.h"
#include "backend.h"
#include "ticks.h"

#define BUFF_SIZE       0x10000

static void disassemble_loop(int start, int end);

unsigned char *mem;
int  c_cpu = CPU_Z80;
int  inverted = 0;
int  c_autolabel = 0;


static void usage(char *program)
{
    printf("z88dk disassembler\n\n");
    printf("%s [options] [file]\n\n",program);
    printf("  -x <file>      Symbol file to read\n");
    printf("                 Use before -o,-s,-e to enable symbols\n");
    printf("  -o <addr>      Address to load code to\n");
    printf("  -s <addr>      Address to start disassembling from\n");
    printf("  -e <addr>      Address to stop disassembling at\n\n");
    printf("  -mz80          Disassemble z80 code\n");
    printf("  -mz180         Disassemble z180 code\n");
    printf("  -mez80         Disassemble ez80 code (short mode)\n");
    printf("  -mz80n         Disassemble z80n code\n");
    printf("  -mr2ka         Disassemble Rabbit 2000A code\n");
    printf("  -mr3k          Disassemble Rabbit 3000 code\n");
    printf("  -mr800         Disassemble R800 code\n");
    printf("  -mgbz80        Disassemble Gameboy z80 code\n");
    printf("  -m8080         Disassemble 8080 code (with z80 mnenomics)\n");
    printf("  -m8085         Disassemble 8085 code (with z80 mnenomics)\n");

    exit(1);
}

static backend_t disassembler_backend = {
    .get_memory = get_memory
};

int main(int argc, char **argv)
{
    char  *program = argv[0];
    char  *endp;
    unsigned int    org = 0;
    int    start = -1;
    int    end = INT_MAX;
    int    loaded = 0;
    int    symbol_addr = -1;

    mem = calloc(1,BUFF_SIZE);

    if ( argc == 1 ) {
        usage(program);
    }

    set_backend(disassembler_backend);

    while ( argc > 1  ) {
        if( argv[1][0] == '-' && argv[2] ) {
            switch (argc--, argv++[1][1]){
            case 'o':
                symbol_addr = symbol_resolve(argv[1], NULL);
                org = (-1 == symbol_addr) ? strtol(argv[1], &endp, 0) : symbol_addr;
                if ( start == -1 ) {
                    start = org;
                }
                argc--; argv++;
                break;
            case 's':
                symbol_addr = symbol_resolve(argv[1], NULL);
                start = (-1 == symbol_addr) ? strtol(argv[1], &endp, 0) : symbol_addr;
                argc--; argv++;
                break;
            case 'e':
                symbol_addr = symbol_resolve(argv[1], NULL);
                end = (-1 == symbol_addr) ? strtol(argv[1], &endp, 0) : symbol_addr;
                argc--; argv++;
                break;
            case 'i':
                inverted = 255;
                break;
            case 'a':
                c_autolabel = 1;
                break;
            case 'x':
                read_symbol_file(argv[1]);
                argc--; argv++;
                break;
            case 'm':
                if ( strcmp(&argv[0][1],"mz80") == 0 ) {
                    c_cpu = CPU_Z80;
                } else if ( strcmp(&argv[0][1],"mz80n") == 0 ) {
                    c_cpu = CPU_Z80N;
                } else if ( strcmp(&argv[0][1],"mz180") == 0 ) {
                    c_cpu = CPU_Z180;
                } else if ( strcmp(&argv[0][1],"mr2ka") == 0 ) {
                    c_cpu = CPU_R2KA;
                } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
                    c_cpu = CPU_R3K;
                } else if ( strcmp(&argv[0][1],"mr800") == 0 ) {
                    c_cpu = CPU_R800;
                } else if ( strcmp(&argv[0][1],"mgbz80") == 0 ) {
                    c_cpu = CPU_GBZ80;
                } else if ( strcmp(&argv[0][1],"m8080") == 0 ) {
                    c_cpu = CPU_8080;
                } else if ( strcmp(&argv[0][1],"m8085") == 0 ) {
                    c_cpu = CPU_8085;
                } else if ( strcmp(&argv[0][1],"mez80") == 0 ) {
                    c_cpu = CPU_EZ80;
                } else {
                    printf("Unknown CPU: %s\n",&argv[0][2]);
                }
                break;
            }
        } else {
            FILE *fp = fopen(argv[1],"rb");

            if ( fp != NULL ) {
                size_t r = fread(mem + (org % BUFF_SIZE), sizeof(char), BUFF_SIZE - (start % BUFF_SIZE), fp);
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
    if ( start < 0 ) {
        start = 0;
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
    int    start2 = start;

    while ( start2 < end ) {
        start2 += disassemble2(start2, buf, sizeof(buf), 0);
        if (!c_autolabel) {
            printf("%s\n",buf);
        }
    }

    if ( c_autolabel ) {
        start2 = start;
        while ( start2 < end ) {
            start2 += disassemble2(start2, buf, sizeof(buf), 0);
            printf("%s\n",buf);
        }
    }
}


uint8_t get_memory(uint16_t pc)
{
    return mem[pc % BUFF_SIZE] ^ inverted;
}
