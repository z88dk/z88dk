#ifndef DEBUG_H
#define DEBUG_H

// debug
extern void debug_add_info_encoded(char *encoded);
extern int debug_find_source_location(int address, const char **filename, int *lineno);
extern void debug_add_cline(const char *filename, int lineno, int level, int scope, const char *address);
extern int debug_resolve_source(char *name);

#endif