//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include <cstring>
#include <string>

// global state
bool g_verbose = false;
bool g_keep_temp_files = false;
std::vector<std::string> g_temp_files;   // temp files to delete on exit

#ifdef _DEBUG
int g_dump_step = 0;
#endif

//-----------------------------------------------------------------------------
// Simple getopt-like implementation for single-letter options
//-----------------------------------------------------------------------------

char* g_optarg = nullptr;
int g_optind = 1;

// Parse single-letter options without or with argument
// optstring format: "o:hv" where ':' indicates the option requires an argument
// Returns the option character, or -1 when done, or '?' for unknown options
int simple_getopt(int argc, char* argv[], const char* optstring) {
    static int opt_pos = 0;

    // Reset state if we finished or haven't started
    if (g_optind >= argc) {
        return -1;
    }

    // Current argument
    char* arg = argv[g_optind];

    // Not an option (doesn't start with '-' or is just '-')
    if (arg[0] != '-' || arg[1] == '\0') {
        return -1;
    }

    // Handle '--' (end of options)
    if (arg[1] == '-' && arg[2] == '\0') {
        g_optind++;
        return -1;
    }

    // Start processing next option character
    if (opt_pos == 0) {
        opt_pos = 1; // Skip the '-'
    }

    char opt = arg[opt_pos];
    if (opt == '\0') {
        // End of this option string, move to next argument
        g_optind++;
        opt_pos = 0;
        return simple_getopt(argc, argv, optstring);
    }

    // Find option in optstring
    const char* opt_ptr = std::strchr(optstring, opt);
    if (opt_ptr == nullptr) {
        // Unknown option
        opt_pos++;
        if (arg[opt_pos] == '\0') {
            g_optind++;
            opt_pos = 0;
        }
        error("Unknown option -" + std::string(1, opt));
        return '?';
    }

    // Check if option requires an argument
    if (opt_ptr[1] == ':') {
        // Option requires an argument
        if (arg[opt_pos + 1] != '\0') {
            // Argument is attached: -ofile
            g_optarg = &arg[opt_pos + 1];
        }
        else {
            // Argument is next: -o file
            if (g_optind + 1 < argc) {
                g_optarg = argv[g_optind + 1];
                g_optind++;
            }
            else {
                // Missing required argument
                error("Option -" + std::string(1, opt) + " requires an argument");
                g_optind++;
                opt_pos = 0;
                return '?';
            }
        }
        g_optind++;
        opt_pos = 0;
    }
    else {
        // No argument required
        g_optarg = nullptr;
        opt_pos++;
        if (arg[opt_pos] == '\0') {
            g_optind++;
            opt_pos = 0;
        }
    }

    return opt;
}
