#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include "ticks.h"



static void disassemble_loop(int start, int end);

unsigned char *mem;
int  c_cpu = CPU_Z80;
int  inverted = 0;


static void usage(char *program)
{
    printf("z88dk disassembler\n\n");
    printf("%s [options] [file]\n\n",program);
    printf("  -o <addr>      Address to load code to\n");
    printf("  -s <addr>      Address to start disassembling from\n");
    printf("  -e <addr>      Address to stop disassembling at\n");
    printf("  -mz80          Disassemble z80 code\n");
    printf("  -mz180         Disassemble z180 code\n");
    printf("  -mez80         Disassemble ez80 code (short mode)\n");
    printf("  -mz80n         Disassemble z80n code\n");
    printf("  -mr2k          Disassemble Rabbit 2000 code\n");
    printf("  -mr3k          Disassemble Rabbit 3000 code\n");
    printf("  -mr800         Disassemble R800 code\n");
    printf("  -mgbz80        Disassemble Gameboy z80 code\n");
    printf("  -m8080         Disassemble 8080 code (with z80 mnenomics)\n");
    printf("  -x <file>      Symbol file to read\n");

    exit(1);
}

int main(int argc, char **argv)
{
    char  *program = argv[0];
    char  *filename;
    char  *endp;
    uint16_t    org = 0;
    int         start = -1;
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
                org = strtol(argv[1], &endp, 0);
                if ( start == -1 ) {
                    start = org;
                }
                argc--; argv++;
                break;
            case 's':
                start = strtol(argv[1], &endp, 0);
                argc--; argv++;
                break;
            case 'e':
                end = strtol(argv[1], &endp, 0);
                argc--; argv++;
                break;
            case 'i':
                inverted = 255;
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
                } else if ( strcmp(&argv[0][1],"mr2k") == 0 ) {
                    c_cpu = CPU_R2K;
                } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
                    c_cpu = CPU_R3K;
                } else if ( strcmp(&argv[0][1],"mr800") == 0 ) {
                    c_cpu = CPU_R800;
                } else if ( strcmp(&argv[0][1],"mgbz80") == 0 ) {
                    c_cpu = CPU_GBZ80;
                } else if ( strcmp(&argv[0][1],"m8080") == 0 ) {
                    c_cpu = CPU_8080;
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
    if ( start < 0 ) {
        start = 0;
    }
    if ( loaded ) {
        disassemble_loop(start % 65536,end);
    } else {
        usage(program);
    }
    exit(0);
}

static void disassemble_loop(int start, int end)
{
    char   buf[256];

    while ( start < end ) {
        start += disassemble2(start, buf, sizeof(buf));
        printf("%s\n",buf);
    }
}


uint8_t get_memory(int pc)
{
    return mem[pc % 65536] ^ inverted;
}
