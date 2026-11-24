/* Compare the T-state model (src/common/ticks_model.c) with cycles measured in the
   z88dk-ticks emulator.  usage: check <measured> <known-gaps>
   <measured> lines are "cpu|instruction|cycles" (bench.sh).  <known-gaps> lines are
   "cpu|instruction" (lines that start with # are comments): an instruction the model is known to
   score differently from the emulator on that CPU.  The check fails when a measured instruction
   differs and is not listed, and when a listed one now matches, so fixing the model means removing
   the entry.  An instruction that was not measured, because it did not assemble or run, is
   ignored either way.  With "-" for <known-gaps> every difference is listed as a gap line.
   An instruction of 30 clocks or more, such as one z80asm replaces with a library routine, matches
   when the model is within a tenth of the emulator: a rough figure is enough for it. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ticks_model.h"

#define MAXCPU 32
static char  cpu_name[MAXCPU][32];
static int   cpu_total[MAXCPU], cpu_bad[MAXCPU], cpu_known[MAXCPU], cpu_unexpected[MAXCPU], ncpu;

#define MAXGAP 512
static char  gap_cpu[MAXGAP][32], gap_ins[MAXGAP][128];
static int   ngap;

static int gap_index(const char *cpu, const char *ins)
{
    for (int i = 0; i < ngap; i++)
        if (!strcmp(gap_cpu[i], cpu) && !strcmp(gap_ins[i], ins)) return i;
    return -1;
}

static int cpu_index(const char *name)
{
    for (int i = 0; i < ncpu; i++)
        if (!strcmp(cpu_name[i], name)) return i;
    if (ncpu == MAXCPU) { fprintf(stderr, "too many CPUs\n"); exit(2); }
    snprintf(cpu_name[ncpu], sizeof cpu_name[0], "%s", name);
    return ncpu++;
}

/* The model's time for an instruction line: its statements, separated by " ; ", added
   up.  A statement that starts with "!" is a taken branch. */
static int score(int cpu, const char *line)
{
    char buf[256], *p = buf, *end;
    int total = 0;

    snprintf(buf, sizeof buf, "%s", line);
    for (;;) {
        int taken = 0, fb = 0;
        end = strstr(p, " ; ");
        if (end) *end = 0;
        if (*p == '!') { taken = 1; p++; }
        total += ticks_for_src(cpu, p, taken, &fb);
        if (!end) break;
        p = end + 3;
    }
    return total;
}

int main(int argc, char **argv)
{
    char ln[512];
    FILE *f;
    int failed = 0, list = 0;

    if (argc != 3) { fprintf(stderr, "usage: check <measured> <known-gaps>|-\n"); return 2; }
    list = !strcmp(argv[2], "-");
    if (!list) {
        if (!(f = fopen(argv[2], "r"))) { perror(argv[2]); return 2; }
        while (fgets(ln, sizeof ln, f)) {
            char *cpu, *ins;
            if (ln[0] == '#' || ln[0] == '\n') continue;
            cpu = strtok(ln, "|"); ins = strtok(NULL, "\n");
            if (!cpu || !ins || ngap == MAXGAP) { fprintf(stderr, "bad line in %s\n", argv[2]); return 2; }
            snprintf(gap_cpu[ngap], sizeof gap_cpu[0], "%s", cpu);
            snprintf(gap_ins[ngap], sizeof gap_ins[0], "%s", ins);
            ngap++;
        }
        fclose(f);
    }
    if (!(f = fopen(argv[1], "r"))) { perror(argv[1]); return 2; }
    while (fgets(ln, sizeof ln, f)) {
        char *cpu = strtok(ln, "|"), *ins = strtok(NULL, "|"), *cyc = strtok(NULL, "|\n");
        int k, model, measured, g;
        if (!cpu || !ins || !cyc) continue;
        k = cpu_index(cpu);
        measured = atoi(cyc);
        model = score(ticks_cpu_from_name(cpu), ins);
        cpu_total[k]++;
        g = gap_index(cpu, ins);
        if (model != measured && !(measured >= 30 && abs(model - measured) * 10 <= measured)) {
            cpu_bad[k]++;
            if (list) printf("%s|%s\n", cpu, ins);
            else if (g < 0) {
                cpu_unexpected[k]++;
                printf("  %-9s %-14s emulator %3d  model %3d\n", cpu, ins, measured, model);
            } else cpu_known[k]++;
        } else if (g >= 0) {
            cpu_unexpected[k]++;
            printf("  %-9s %-14s now matches the emulator (%d): remove it from known-gaps.txt\n", cpu, ins, measured);
        }
    }
    fclose(f);
    if (list) return 0;
    for (int i = 0; i < ncpu; i++) {
        printf("%-9s %3d of %3d instructions match the emulator%s%s\n", cpu_name[i],
               cpu_total[i] - cpu_bad[i], cpu_total[i],
               cpu_known[i] ? " (known gaps)" : "", cpu_unexpected[i] ? "  <-- UNEXPECTED" : "");
        if (cpu_unexpected[i]) failed = 1;
    }
    return failed;
}
