/* Shared by enums_a.c and enums_b.c: the enum is defined in the header, so
 * each module writes the same N: record and no module's file name is in it. */
enum shared { SH_ONE = 1, SH_TWO };
