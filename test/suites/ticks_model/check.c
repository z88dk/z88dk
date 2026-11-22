/* Compare the T-state model (src/common/ticks_model.c) with cycles measured in the
   z88dk-ticks emulator.  usage: check <measured> <known-gaps>
   <measured> lines are "cpu|instruction|cycles" (bench.sh).  <known-gaps> lines are
   "cpu count": the number of instructions the model is known to get wrong on that CPU
   (0 when a CPU is not listed).  The check fails when a count differs from its entry,
   in either direction, so fixing the model means lowering the entry. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ticks_model.h"

#define MAXCPU 32
static char  cpu_name[MAXCPU][32];
static int   cpu_total[MAXCPU], cpu_bad[MAXCPU], cpu_known[MAXCPU], ncpu;

static int cpu_index(const char *name)
{
    for (int i = 0; i < ncpu; i++)
        if (!strcmp(cpu_name[i], name)) return i;
    if (ncpu == MAXCPU) { fprintf(stderr, "too many CPUs\n"); exit(2); }
    snprintf(cpu_name[ncpu], sizeof cpu_name[0], "%s", name);
    return ncpu++;
}

int main(int argc, char **argv)
{
    char ln[512];
    FILE *f;
    int failed = 0;

    if (argc != 3) { fprintf(stderr, "usage: check <measured> <known-gaps>\n"); return 2; }
    if (!(f = fopen(argv[2], "r"))) { perror(argv[2]); return 2; }
    while (fgets(ln, sizeof ln, f)) {
        char name[32]; int n;
        if (sscanf(ln, "%31s %d", name, &n) == 2) cpu_known[cpu_index(name)] = n;
    }
    fclose(f);
    if (!(f = fopen(argv[1], "r"))) { perror(argv[1]); return 2; }
    while (fgets(ln, sizeof ln, f)) {
        char *cpu = strtok(ln, "|"), *ins = strtok(NULL, "|"), *cyc = strtok(NULL, "|\n");
        int fb = 0, k, model, measured;
        if (!cpu || !ins || !cyc) continue;
        k = cpu_index(cpu);
        measured = atoi(cyc);
        model = ticks_for_src(ticks_cpu_from_name(cpu), ins, 0, &fb);
        cpu_total[k]++;
        if (model != measured) {
            cpu_bad[k]++;
            if (cpu_bad[k] > cpu_known[k])
                printf("  %-9s %-14s emulator %3d  model %3d\n", cpu, ins, measured, model);
        }
    }
    fclose(f);
    for (int i = 0; i < ncpu; i++) {
        int ok = cpu_bad[i] == cpu_known[i];
        printf("%-9s %2d of %2d instructions match the emulator%s%s\n", cpu_name[i],
               cpu_total[i] - cpu_bad[i], cpu_total[i],
               cpu_known[i] ? " (known gaps)" : "", ok ? "" : "  <-- UNEXPECTED");
        if (!ok) {
            printf("          %d differ, %d expected: %s\n", cpu_bad[i], cpu_known[i],
                   cpu_bad[i] > cpu_known[i] ? "the model regressed" : "the model improved, lower its entry in known-gaps.txt");
            failed = 1;
        }
    }
    return failed;
}
