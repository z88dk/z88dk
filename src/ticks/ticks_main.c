#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ticks.h"
#include "ticks_lua.h"
#include "cpu.h"
#include "debugger.h"
#include "backend.h"
#include "profiler.h"

extern backend_t ticks_debugger_backend;

static long long c_max_runticks = 1e8;
static char  *c_output = NULL;
static char  *c_memory_model = "standard";


int    c_rc2014_mode = 0;
int    c_cpm_mode = 0;
int    c_rom_size = 0;
int    c_ioport = -1;
int    c_iotimer = -1;
int    c_mmtimer = -1;
int    c_autolabel = 0;
int    c_z80asm_tests = 0;
int    c_no_cycles = 0;      /* suppress end-of-run cycle-count printf */
static const char *c_lua_file = NULL;

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

static void write_memory_range(FILE *fh, uint16_t address, size_t length, memtype type)
{
    size_t i;
    for (i = 0; i < length; i++)
        fputc(peek_memory((uint16_t)(address + i), type), fh);
}

static int load_memory_range(FILE *fh, uint16_t address, size_t length, memtype type)
{
    size_t i;
    int value;
    for (i = 0; i < length; i++) {
        value = fgetc(fh);
        if (value == EOF)
            return 0;
        load_memory((uint16_t)(address + i), (uint8_t)value, type);
    }
    return 1;
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
            write_memory_range(fh, 0x4000, 0xc000, MEM_TYPE_INST);
        } else if ( !strcasecmp(strchr(c_output, '.'), ".scr" ) ) {
            write_memory_range(fh, 0x4000, 0x1b00, MEM_TYPE_INST);
        } else {
            write_memory_range(fh, 0, 65536, MEM_TYPE_INST);
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
    printf("  -pc X          X (symbol or hex value) is the initial PC value\n");
    printf("  -start X       X (symbol or hex value) is the PC condition to start the counter\n");
    printf("  -end X         X (symbol or hex value) is the PC condition to exit\n");
    printf("  -counter X     X in decimal is another condition to exit (default 100000000)\n");
    printf("  -int X         X in decimal are number of cycles for periodic interrupts\n");
    printf("  -d             Enable debugger\n");
    printf("  -v             Verbose logging\n");
    printf("  -l X           Load file to address\n");
    printf("  -b <model>     Memory model (zxn/zx/z180/msx)\n");
    printf("  -banks         Load <input>_BANK_nn.bin bank images (Rabbit, ZX Next or MSX model)\n");
    printf("  -m8080         Emulate an 8080\n");
    printf("  -m8085         Emulate an 8085 (mostly)\n");
    printf("  -mvm1          Emulate a KR580VM1\n");
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
    printf("  -lua <file>    Load Lua I/O and memory callbacks from <file>\n");
    printf("                 also searches $ZCCCFG/../ticks/memory\n");
    printf("                 memory_read(addr, type, cycles) returns byte or nil;\n");
    printf("                 memory_write(addr, value, type, cycles) returns -1\n");
    printf("                 type is ticks.MEM_TYPE_* (inst/data/stack/logical/physical).\n");
    printf("                 if unhandled, otherwise the write is consumed.\n");
    printf("  -b lua         Use the Lua-backed memory model (requires -lua).\n");
    printf("  -iochar X      Set port X to be character input/output\n");
    printf("  -iotimer X     Set port X to the cycle-count timer (0..255)\n");
    printf("  -mmtimer X     Symbol or hex address for the 8-byte count\n");
    printf("                 A write to -iotimer resets that count; a read\n");
    printf("                 stores it little-endian and returns 0 in A\n");
    printf("  -no-cycles     Suppress end-of-run cycle-count printf (makes ticks\n");
    printf("                 silent on normal exit; program's own stdout unaffected).\n");
    printf("                 Useful for using ticks as a drop-in CP/M emulator in\n");
    printf("                 test suites where only the program's output should appear.\n");
    printf("  -output <file> dumps the RAM content to a 64K file\n");
    printf("  -rom X         write-protect memory, X in hexadecimal is first RAM address\n");
    printf("  -w X           Maximum amount of running time (400000000 cycles per unit)\n");
    printf("  -x <file>      Symbol or map file to read; must precede -pc,-start,-end,-mmtimer\n");
    printf("                 for symbol-name resolution in those options\n");
    printf("  -script <file> Script file to run at the console\n\n");
    printf("  Default values for -pc, -start and -end are 0000 if omitted.\n");
    printf("  When the program exits, it'll show the number of cycles between start and end trigger in decimal\n\n");
}
  

static int c_load_banks = 0;

/* Bank images: <name>_BANK_nn.bin, as z80asm writes them next to the program.
   memory_bank_store() knows where bank nn goes in the banking model. */
static void load_bank_images(const char *input)
{
  char     base[1024], path[1100];
  char    *dot;
  int      bank, c;
  unsigned i;
  FILE    *bf;

  snprintf(base, sizeof(base), "%s", input);
  dot = strrchr(base, '.');
  if ( dot && !strchr(dot, '/') && !strchr(dot, '\\') )
    *dot = 0;

  for ( bank = 1; bank < 4096; bank++ ) {
    snprintf(path, sizeof(path), "%s_BANK_%02X.bin", base, bank);
    if ( (bf = fopen(path, "rb")) == NULL )
      continue;
    for ( i = 0; (c = fgetc(bf)) != EOF; i++ )
      memory_bank_store(bank, i, c);
    fclose(bf);
  }
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

  {
    int argi;
    for (argi = 1; argi + 1 < argc; argi++) {
      if (strcmp(argv[argi], "--") == 0)
        break;
      if (strcmp(argv[argi], "-lua") == 0)
        c_lua_file = argv[argi + 1];
      if (strcmp(argv[argi], "-b") == 0 && strcmp(argv[argi + 1], "lua") == 0)
        c_memory_model = "lua";
    }
    if (strcmp(c_memory_model, "lua") == 0 && c_lua_file == NULL)
      exit_log(1, "-b lua requires -lua <file>\n");
    if (lua_io_init(c_lua_file) != 0)
      exit(EXIT_FAILURE);
  }

  while (argc > 1){
    if( argv[1][0] == '-' && argv[2] )
      switch (argc--, argv++[1][1]){
        case 'w':
          alarmtime = strtol(argv[1], NULL, 10);
          c_max_runticks = 400000000LL * alarmtime;
          break;
        case 'b':
          if ( strcmp(&argv[0][1], "banks") == 0 ) {
            c_load_banks = 1;
            argv--;
            argc++;
          } else {
            c_memory_model = argv[1];
          }
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
          } else if ( strcmp(&argv[0][1], "iotimer") == 0 ) {
            char *end = NULL;
            long port = strtol(argv[1], &end, 0);
            if (end == argv[1] || *end || port < 0 || port > 255)
              exit_log(1, "-iotimer port must be 0..255\n");
            c_iotimer = (int)port;
          } else {
            intr= strtol(argv[1], NULL, 10);
          }
          break;
        case 'l':
          if (strcmp(&argv[0][1], "lua") == 0)
            c_lua_file = argv[1];
          else
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
          if ( strcmp(&argv[0][1], "mmtimer") == 0 ) {
            char *end = NULL;
            long addr;
            symbol_addr = symbol_resolve(argv[1], NULL);
            if (symbol_addr != -1) {
              c_mmtimer = symbol_addr;
            } else {
              addr = strtol(argv[1], &end, 16);
              if (end == argv[1] || *end || addr < 0 || addr > 0xffff)
                exit_log(1, "-mmtimer needs a symbol or a hex address\n");
              c_mmtimer = (int)addr;
            }
            break;
          }
          if ( strcmp(&argv[0][1],"mz80") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"mz80_strict") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"m8080") == 0 ) {
            c_cpu = CPU_8080;
          } else if ( strcmp(&argv[0][1],"m8085") == 0 ) {
            c_cpu = CPU_8085;
          } else if ( strcmp(&argv[0][1],"mvm1") == 0 ) {
            c_cpu = CPU_KR580VM1;
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
        case 'n':
          if (strcmp(&argv[0][1], "no-cycles") == 0) {
            c_no_cycles = 1;
            argv--;
            argc++;
          } else {
            fprintf(stderr, "\nWrong Argument: %s\n", argv[0]);
            exit(EXIT_FAILURE);
          }
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
            { int argi; for (argi = 0; argi < cmd_arguments_len % 256; argi++) load_memory(0x81 + argi, (uint8_t)cmd_arguments[argi], MEM_TYPE_DATA); }
          } else {
            put_memory(65280,cmd_arguments_len % 256);
            { int argi; for (argi = 0; argi < cmd_arguments_len % 256; argi++) load_memory(65281 + argi, (uint8_t)cmd_arguments[argi], MEM_TYPE_DATA); }
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
      else if( strchr(argv[1], '.') && !strcasecmp(strchr(argv[1], '.'), ".com" ) ){
        /* .com before "rc2014" name match: CP/M apps may be named *rc2014*.com */
        load_memory(5, 0xED, MEM_TYPE_INST);
        load_memory(6, 0xFE, MEM_TYPE_INST);
        load_memory(7, 0xC9, MEM_TYPE_INST);
        // Trap BIOS entry as well + 3 + 5
        load_memory(0, 0xED, MEM_TYPE_INST);
        load_memory(1, 0x05, MEM_TYPE_INST);
        load_memory(2, 0x00, MEM_TYPE_INST);

        load_memory(8, 0xED, MEM_TYPE_INST);
        load_memory(9, 0xFE, MEM_TYPE_INST);
        load_memory(10, 0xC9, MEM_TYPE_INST);

        load_memory(11, 0xED, MEM_TYPE_INST);
        load_memory(12, 0xFE, MEM_TYPE_INST);
        load_memory(13, 0xC9, MEM_TYPE_INST);

        pc = 256;
        c_cpm_mode = 1;
        // CP/M emulator
        if (256 + size > 0x10000) { fclose(fh); exit_log(1, "Binary too large: %d bytes at 0x0100 exceeds 64K\n", size); }
        if (!load_memory_range(fh, 256, size, MEM_TYPE_INST)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else if( strstr(argv[1], "rc2014") != NULL ) {
        load_memory(0x08, 0xED, MEM_TYPE_INST);
        load_memory(0x09, 0xFE, MEM_TYPE_INST);
        load_memory(0x0a, 0xC9, MEM_TYPE_INST);
        load_memory(0x10, 0xED, MEM_TYPE_INST);
        load_memory(0x11, 0xFE, MEM_TYPE_INST);
        load_memory(0x12, 0xC9, MEM_TYPE_INST);
        load_memory(0x18, 0xED, MEM_TYPE_INST);
        load_memory(0x19, 0xFE, MEM_TYPE_INST);
        load_memory(0x1a, 0xC9, MEM_TYPE_INST);
        c_rc2014_mode = 1;
        if (pc + size > 0x10000) { fclose(fh); exit_log(1, "Binary too large: %d bytes at 0x%04X exceeds 64K\n", size, pc); }
        if (!load_memory_range(fh, pc, size, MEM_TYPE_INST)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else {
        if (!load_memory_range(fh, load_address, size, MEM_TYPE_INST)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      }
      if ( c_load_banks ) {
        if ( !memory_has_banks() )
          exit_log(1, "-banks needs a Rabbit, ZX Next or MSX memory model\n");
        load_bank_images(argv[1]);
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


  if ((c_iotimer >= 0) != (c_mmtimer >= 0))
    exit_log(1, "-iotimer and -mmtimer must be used together\n");
  if (c_iotimer >= 0 && c_ioport >= 0 && (c_iotimer & 0xff) == (c_ioport & 0xff))
    exit_log(1, "-iotimer and -iochar must use different ports\n");

  cpu_run(c_max_runticks, intr, intr, start, end);

  if ( alarmtime != 0 ) {
     if ( c_rc2014_mode ) exit(l);
     /* CP/M 2.2 CRT stores the process exit value at base+0x80 before warm boot
      * (jp 0).  Hitting -end 0 is the normal completion path for .com files. */
     if ( c_cpm_mode ) exit(get_memory_data(0x80));
      /* We running as a test, we should never reach the end, so exit with error */
      exit(1);
  }

  write_output();
  if ( c_cpm_mode ) exit(get_memory_data(0x80));
}
