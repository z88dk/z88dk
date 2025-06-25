#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ticks.h"
#include "cpu.h"
#include "debugger.h"
#include "backend.h"
#include "profiler.h"

extern backend_t ticks_debugger_backend;

static long long c_max_runticks = 1e8;
static char  *c_output = NULL;
static char  *c_memory_model = "standard";


int    c_rc2014_mode = 0;
int    c_rom_size = 0;
int    c_ioport = -1;
int    c_autolabel = 0;
int    c_z80asm_tests = 0;

static char   cmd_arguments[255];
static int    cmd_arguments_len = 0;


static void exit_log(int code, char *fmt, ...)
{
    va_list  ap;

    va_start(ap, fmt);
    if ( fmt != NULL ) {
       fprintf(stderr, "ticks: ");
       vfprintf(stderr, fmt, ap);
    }

    va_end(ap);
    exit(code);
}

static void write_output()
{
    FILE *fh;
    uint8_t t, r, w;

    // Output is used by z80asm tests, pretend that we're a z80 so flags are
    // written out in that way
    if( c_output ){
        if (c_z80asm_tests) c_cpu = CPU_Z80;
        fh= fopen(c_output, "wb+");
        if( !fh ) {
            fprintf(stderr, "\nCannot create or write in file: %s\n", c_output);
            exit(EXIT_FAILURE);
        }

        if (!strcasecmp(strchr(c_output, '.'), ".sna" ) ) {
            put_memory(--sp,pc>>8),
            put_memory(--sp,pc),
            fwrite(&i, 1, 1, fh),
            fwrite(&l_, 1, 1, fh),
            fwrite(&h_, 1, 1, fh),
            fwrite(&e_, 1, 1, fh),
            fwrite(&d_, 1, 1, fh),
            fwrite(&c_, 1, 1, fh),
            fwrite(&b_, 1, 1, fh),
            t= f(),
            ff= ff_,
            fr= fr_,
            fa= fa_,
            fb= fb_,
            w= f(),
            fwrite(&w, 1, 1, fh),
            fwrite(&a_, 1, 1, fh),
            fwrite(&l, 1, 1, fh),
            fwrite(&h, 1, 1, fh),
            fwrite(&e, 1, 1, fh),
            fwrite(&d, 1, 1, fh),
            fwrite(&c, 1, 1, fh),
            fwrite(&b, 1, 1, fh),
            fwrite(&yl, 1, 1, fh),
            fwrite(&yh, 1, 1, fh),
            fwrite(&xl, 1, 1, fh),
            fwrite(&xh, 1, 1, fh),
            iff<<= 2,
            fwrite(&iff, 1, 1, fh),
            r= ((r&127)|(r7&128)),
            fwrite(&r, 1, 1, fh),
            fwrite(&t, 1, 1, fh),
            fwrite(&a, 1, 1, fh),
            fwrite(&sp, 2, 1, fh),
            fwrite(&im, 1, 1, fh),
            fwrite(&w, 1, 1, fh),
            fwrite(get_memory_addr(0x4000, MEM_TYPE_INST), 1, 0xc000, fh);
        } else if ( !strcasecmp(strchr(c_output, '.'), ".scr" ) ) {
            fwrite(get_memory_addr(0x4000, MEM_TYPE_INST), 1, 0x1b00, fh);
        } else {
            fwrite(get_memory_addr(0, MEM_TYPE_INST), 1, 65536, fh);
            w= f();
            fwrite(&w, 1, 1, fh);    // 10000 F
            fwrite(&a, 1, 1, fh);    // 10001 A
            fwrite(&c, 1, 1, fh);    // 10002 C
            fwrite(&b, 1, 1, fh);    // 10003 B
            fwrite(&l, 1, 1, fh);    // 10004 L
            fwrite(&h, 1, 1, fh);    // 10005 H
            fwrite(&pc, 2, 1, fh);   // 10006 PCl
                                    // 10007 PCh
            fwrite(&sp, 2, 1, fh);   // 10008 SPl
                                    // 10009 SPh
            fwrite(&i, 1, 1, fh);    // 1000a I
            r= ((r&127)|(r7&128));
            fwrite(&r, 1, 1, fh);    // 1000b R
            fwrite(&e, 1, 1, fh);    // 1000c E
            fwrite(&d, 1, 1, fh);    // 1000d D
            fwrite(&c_, 1, 1, fh);   // 1000e C'
            fwrite(&b_, 1, 1, fh);   // 1000f B'
            fwrite(&e_, 1, 1, fh);   // 10010 E'
            fwrite(&d_, 1, 1, fh);   // 10011 D'
            fwrite(&l_, 1, 1, fh);   // 10012 L'
            fwrite(&h_, 1, 1, fh);   // 10013 H'
            ff= ff_;
            fr= fr_;
            fa= fa_;
            fb= fb_;
            w= f();
            fwrite(&w, 1, 1, fh);    // 10014 F'
            fwrite(&a_, 1, 1, fh);   // 10015 A'
            fwrite(&yl, 1, 1, fh);   // 10016 IYl
            fwrite(&yh, 1, 1, fh);   // 10017 IYh
            fwrite(&xl, 1, 1, fh);   // 10018 IXl
            fwrite(&xh, 1, 1, fh);   // 10019 IXh
            fwrite(&iff, 1, 1, fh);  // 1001a IFF
            fwrite(&im, 1, 1, fh);   // 1001b IM
            fwrite(&mp, 2, 1, fh);   // 1001c MEMPTRl
                                     // 1001d MEMPTRh

            long l = 0;
            fwrite(&l, 4, 1, fh);  // 1001e wavlen
            fwrite(&l, 4, 1, fh);   // 10022 sttap                      
        }
        fclose(fh);
    }
}

static void usage(void)
{
    printf("z88dk-ticks is derived from a silent Z80 emulator by Antonio Villena (v0.14c beta)\n\n");
    printf("  z88dk-ticks [-x <file>] [-pc X] [-start X] [-end X] [-counter X] <input_file>\n\n");
    printf("  <input_file>   File between 1 and 65536 bytes with Z80 machine code\n");
    printf("  -trace         outputs register values and disassembly while executing\n");
    printf("  -pc X          X in hexadecimal is the initial PC value\n");
    printf("  -start X       X in hexadecimal is the PC condition to start the counter\n");
    printf("  -end X         X in hexadecimal is the PC condition to exit\n");
    printf("  -counter X     X in decimal is another condition to exit\n");
    printf("  -int X         X in decimal are number of cycles for periodic interrupts\n");
    printf("  -d             Enable debugger\n");
    printf("  -v             Verbose logging\n");
    printf("  -l X           Load file to address\n");
    printf("  -b <model>     Memory model (zxn/zx/z180/msx)\n");
    printf("  -m8080         Emulate an 8080\n");
    printf("  -m8085         Emulate an 8085 (mostly)\n");
    printf("  -mgbz80        Emulate a gbz80 (mostly)\n");
    printf("  -mz80          Emulate a z80\n");
    printf("  -mz80_strict   Emulate a z80\n");
    printf("  -mz180         Emulate a z180\n");
    printf("  -mr2ka         Emulate a Rabbit 2000\n");
    printf("  -mr3k          Emulate a Rabbit 3000\n");
    printf("  -mr4k          Emulate a Rabbit 4000\n");
    printf("  -mr5k          Emulate a Rabbit 5000\n");
    printf("  -mr6k          Emulate a Rabbit 6000\n");
    printf("  -mz80n         Emulate a Spectrum Next z80n\n");
    printf("  -mez80_z80     Emulate an ez80 (z80 mode)\n");
    printf("  -mr800         Emulate a r800 (ticks may not be accurate)\n");
    printf("  -mkc160        Emulate a kc160\n");
    printf("  -mkc160_z80    Emulate a kc160 (z80 mode)\n");
    printf("  -ide0 <file>    file to be ide device 0\n");
    printf("  -ide1 <file>   Set file to be ide device 1\n");
    printf("  -iochar X      Set port X to be character input/output\n");
    printf("  -output <file> dumps the RAM content to a 64K file\n");
    printf("  -rom X         write-protect memory, X in hexadecimal is first RAM address\n");
    printf("  -w X           Maximum amount of running time (400000000 cycles per unit)\n");
    printf("  -x <file>      Symbol or map file to read\n");
	printf("  -script <file> Script file to run at the console\n");
    printf("                 Use before -pc,-start,-end to enable symbols\n\n");
    printf("  Default values for -pc, -start and -end are 0000 if omitted.\n");
    printf("  When the program exits, it'll show the number of cycles between start and end trigger in decimal\n\n");
}
  

int main (int argc, char **argv){
  int size= 0, start= 0, end= 0, intr= 0, tap= 0, alarmtime = 0, load_address = 0, symbol_addr = -1;
  uint8_t opc, w, r, u;
  FILE * fh;

  hook_init();
  set_backend(ticks_debugger_backend);
  apu_reset();

  if( argc==1 ) {
    usage();
    exit(EXIT_SUCCESS);
  }

  while (argc > 1){
    if( argv[1][0] == '-' && argv[2] )
      switch (argc--, argv++[1][1]){
        case 'w':
          alarmtime = strtol(argv[1], NULL, 10);
          c_max_runticks = 400000000LL * alarmtime;
          break;
        case 'b':
          c_memory_model = argv[1];
          break;
        case 'p':
          symbol_addr= symbol_resolve(argv[1], NULL);
          pc= (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
          break;
        case 's':
			if (strcmp(&argv[0][1], "start") == 0) {
				symbol_addr = symbol_resolve(argv[1], NULL);
				start = (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
			}
			else if (strcmp(&argv[0][1], "script") == 0) {
				script_file = argv[1];
			}
          break;
        case 'e':
          symbol_addr= symbol_resolve(argv[1], NULL);
          end= (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
          break;
        case 'r':
          c_rom_size= strtol(argv[1], NULL, 16);
          break;
        case 'i':
          if ( strcmp(&argv[0][1], "ide0") == 0 ) {
            hook_io_set_ide_device(0, argv[1]);
          } else if ( strcmp(&argv[0][1], "ide1") == 0 ) {
            hook_io_set_ide_device(1, argv[1]);
          } else if ( strcmp(&argv[0][1], "iochar") == 0 ) {
            c_ioport = strtol(argv[1], NULL, 10);
          } else {
            intr= strtol(argv[1], NULL, 10);
          }
          break;
        case 'l':
          load_address = pc = strtol(argv[1], NULL, 0);
          break;
        case 'c':
          sscanf(argv[1], "%llu", &c_max_runticks);
          c_max_runticks<0 && (c_max_runticks= 9e18);
          break;
        case 'd':
          debugger_active = 1;
          debugger_init();
          argv--;
          argc++;
          break;
        case 'v':
          verbose = 1;
          argv--;
          argc++;
          break;
        case 'x':
          read_symbol_file(argv[1]);
          break;
        case 'm':
          if ( strcmp(&argv[0][1],"mz80") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"mz80_strict") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"m8080") == 0 ) {
            c_cpu = CPU_8080;
          } else if ( strcmp(&argv[0][1],"m8085") == 0 ) {
            c_cpu = CPU_8085;
          } else if ( strcmp(&argv[0][1],"mz180") == 0 ) {
            c_cpu = CPU_Z180;
          } else if ( strcmp(&argv[0][1],"mz80n") == 0 ) {
            c_cpu = CPU_Z80N;
            c_memory_model = "zxn";
          } else if ( strcmp(&argv[0][1],"mr2ka") == 0 ) {
            c_cpu = CPU_R2KA;
          } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
            c_cpu = CPU_R3K;
          } else if ( strcmp(&argv[0][1],"mr4k") == 0 ) {
            c_cpu = CPU_R4K;
          } else if ( strcmp(&argv[0][1],"mr5k") == 0 ) {
            c_cpu = CPU_R4K;
          } else if ( strcmp(&argv[0][1],"mr6k") == 0 ) {
            c_cpu = CPU_R6K;
          } else if ( strcmp(&argv[0][1],"mez80_z80") == 0 ) {
            c_cpu = CPU_EZ80;
          } else if ( strcmp(&argv[0][1],"mgbz80") == 0 ) {
            c_cpu = CPU_GBZ80;
          } else if ( strcmp(&argv[0][1],"mr800") == 0 ) {
            c_cpu = CPU_R800;
          } else if ( strcmp(&argv[0][1],"mkc160") == 0 ) {
            c_cpu = CPU_KC160;
          } else if ( strcmp(&argv[0][1],"mkc160_z80") == 0 ) {
            c_cpu = CPU_KC160_Z80;
          } else {
            fprintf(stderr, "\nUnknown CPU: %s\n",&argv[0][1]);
            exit(EXIT_FAILURE);
          }
          argv--;
          argc++;
          break;
        case 'o':
          c_output= argv[1];
          break;
        case 't':
          if (strcmp(&argv[0][1], "trace") == 0) {
            debugger_active = 0;
            trace = 1;
            argv--;
            argc++;
          } else {
            fprintf(stderr, "\nWrong Argument: %s\n", argv[0]);
            exit(EXIT_FAILURE);
          }
          break;
		case '-':
          while ( argc > 1 ) {
            // I think windows is now comformant with snprintf? Either way, we can't grow the arugment buffer...
            cmd_arguments_len += snprintf(cmd_arguments + cmd_arguments_len, sizeof(cmd_arguments) - cmd_arguments_len, "%s%s",cmd_arguments_len > 0 ? " " : "", argv[1]);
            argc--;
            argv++;
          }
          if ( pc == 256 ) {
            put_memory(0x80,cmd_arguments_len % 256);
            memcpy(get_memory_addr(0x81,MEM_TYPE_DATA), cmd_arguments, cmd_arguments_len % 256);
          } else {
            put_memory(65280,cmd_arguments_len % 256);
            memcpy(get_memory_addr(65281, MEM_TYPE_DATA), cmd_arguments, cmd_arguments_len % 256);
          }
          break;
        case 'z':
          if (strcmp(&argv[0][1], "z80asm-tests") == 0) {
                c_z80asm_tests = 1;
                argv--;
                argc++;
                break;
          }
        default:
          fprintf(stderr, "\nWrong Argument: %s\n", argv[0]);
          exit(EXIT_FAILURE);
      }
    else{
      if ( israbbit() )
        c_memory_model = "rabbit";
      memory_init(c_memory_model);

      fh= fopen(argv[1], "rb");
      if( !fh )
        fprintf(stderr, "\nFile not found: %s\n", argv[1]),
        exit(EXIT_FAILURE);
      fseek(fh, 0, SEEK_END);
      size= ftell(fh);
      rewind(fh);
      if( size>65536 && size!=65574 )
        fprintf(stderr, "\nIncorrect length: %d\n", size),
        exit(EXIT_FAILURE);
      else if( strstr(argv[1], "rc2014") != NULL ) {
        *get_memory_addr(0x08, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x09, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x0a, MEM_TYPE_INST) = 0xC9;
        *get_memory_addr(0x10, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x11, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x12, MEM_TYPE_INST) = 0xC9;
        *get_memory_addr(0x18, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x19, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x1a, MEM_TYPE_INST) = 0xC9;
        c_rc2014_mode = 1;
        if (1 != fread(get_memory_addr(pc, MEM_TYPE_INST), size, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else if( !strcasecmp(strchr(argv[1], '.'), ".com" ) ){
        *get_memory_addr(5, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(6, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(7, MEM_TYPE_INST) = 0xC9;
        // Trap BIOS entry as well + 3 + 5
        *get_memory_addr(0, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(1, MEM_TYPE_INST) = 0x05;
        *get_memory_addr(2, MEM_TYPE_INST) = 0x00;

        *get_memory_addr(8, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(9, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(10, MEM_TYPE_INST) = 0xC9;

        *get_memory_addr(11, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(12, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(13, MEM_TYPE_INST) = 0xC9;

        pc = 256;
        // CP/M emulator
        if (1 != fread(get_memory_addr(256, MEM_TYPE_INST), size, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else {
        int l;
        for ( l = 0; l < size; l++ ) {
          *get_memory_addr(load_address+l, MEM_TYPE_INST) = fgetc(fh);
        }
      }
    }
    ++argv;
    --argc;
  }

  fclose(fh);
  if (!size) {
    fprintf(stderr, "\nFile not specified or zero length\n");
    exit(EXIT_FAILURE);
  }


  cpu_run(c_max_runticks, intr, intr, start, end);

  if ( alarmtime != 0 ) {
     if ( c_rc2014_mode ) exit(l);
      /* We running as a test, we should never reach the end, so exit with error */
      exit(1);
  }

  write_output();
}
