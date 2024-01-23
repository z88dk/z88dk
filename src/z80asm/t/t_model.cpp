//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void test_static_defines() {
    StaticDefines defs;
    int value;
    bool found[4] = { 0 };
    string names[4] = { "", "one", "two", "three" };

    IS(defs.size(), static_cast<size_t>(0));

    defs.add("one");
    defs.add("two", 2);
    defs.add("three", 3);
    IS(defs.size(), static_cast<size_t>(3));

    OK(defs.lookup("one", value)); IS(value, 1);
    OK(defs.lookup("two", value)); IS(value, 2);
    OK(defs.lookup("three", value)); IS(value, 3);
    NOK(defs.lookup("four", value)); IS(value, 0);

    OK(defs.exists("one")); 
    OK(defs.exists("two")); 
    OK(defs.exists("three")); 
    NOK(defs.exists("four")); 

    defs.remove("three");
    IS(defs.size(), static_cast<size_t>(2));

    defs.remove("three");
    IS(defs.size(), static_cast<size_t>(2));

    defs.add("three", 3);

    auto it = defs.begin();
    OK(it != defs.end()); found[it->second] = true; IS(it->first, names[it->second]); ++it;
    OK(it != defs.end()); found[it->second] = true; IS(it->first, names[it->second]); ++it;
    OK(it != defs.end()); found[it->second] = true; IS(it->first, names[it->second]); ++it;
    OK(it == defs.end());
    OK(found[1] && found[2] && found[3]);

    RUN_OK("exec_static_defines1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: duplicate definition: one\n");

    RUN_OK("exec_static_defines2");
    STR_IS(test_exec_out, "Predefined constant: one = 1\n");
    STR_IS(test_exec_err, "");
}

int exec_static_defines1() {
    int value;
    g_static_defines.add("one", 1);
    g_static_defines.add("one", 2);
    xassert(g_static_defines.lookup("one", value));
    xassert(value == 1);
    return EXIT_SUCCESS;
}

int exec_static_defines2() {
    g_args.opt_verbose = true;
    g_static_defines.add("one", 1);
    g_static_defines.add("one", 1);
    return EXIT_SUCCESS;
}
