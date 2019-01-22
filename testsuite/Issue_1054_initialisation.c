
// Values should be dropped inline
static char a[][10] = {
        {"a"},
        {"b"}
};

// Should be placed in rodata
static const char *x[] = {
        {"a"},
        {"b"}
};
