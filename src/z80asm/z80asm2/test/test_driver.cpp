//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "test_driver.h"
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

static constexpr std::string_view RunAllName = ":all";

#define X(name) void name(const std::vector<std::string>& args);
#include "test_driver.def"
#undef X

struct TestFunction {
    std::string_view name;
    void (*func)(const std::vector<std::string>& args);
};

static const std::vector<TestFunction> all_tests = {
#define X(name) { #name, name },
#include "test_driver.def"
#undef X
};

const std::vector<std::string_view>& test_names() {
    static const std::vector<std::string_view> tests =
    []() {
        std::vector<std::string_view> m;
        m.reserve(all_tests.size());
        for (auto& [name, func] : all_tests) {
            m.push_back(name);
        }
        return m;
    }
    ();
    return tests;
}

bool run_test(std::string_view test_name,
              const std::vector<std::string>& args) {
    bool run_all = (test_name == RunAllName);
    std::string separator = std::string(80, '-') + "\n";

    bool found_test = false;
#define X(name) \
	if (run_all || test_name == #name) { \
		std::cout << separator << "TEST " #name << std::endl << separator; \
		name(args); \
		std::cout << std::endl; \
		found_test = true; \
	}
#include "test_driver.def"
#undef X
    return found_test;
}

#endif
