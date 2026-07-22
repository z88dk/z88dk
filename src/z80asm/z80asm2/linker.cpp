//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "files.h"
#include "linker.h"
#include "obj_file.h"
#include "source_loc.h"
#include "strings.h"
#include <filesystem>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

#if 0
static bool load_input_modules(LinkContext& context,
                               const std::vector<std::string>& filenames,
                               std::string_view output_dir) {
    for (auto& filename : filenames) {
        std::string o_filename = get_o_filename(filename, output_dir);

        auto obj_lib = std::make_unique<ObjectLibrary>();
        if (!read_object_library(*obj_lib, o_filename)) {
            return false;   // error already reported
        }

        context.input_modules.push_back(std::move(obj_lib));
    }

    return true;
}

static std::string resolve_library_path(const std::string& libname,
                                        const std::vector<std::string>& library_paths) {
    // add .lib extrension if not present
    std::string lib_filename;
    if (is_lib_filename(libname)) {
        lib_filename = libname;
    }
    else {
        lib_filename = libname + std::string(lib_extension);
    }

    // search current directory first
    if (std::filesystem::exists(lib_filename)) {
        return lib_filename;
    }

    // search library paths
    for (auto& path : library_paths) {
        std::string candidate = path + "/" + lib_filename;
        if (std::filesystem::exists(candidate)) {
            return candidate;
        }
    }

    return "";  // not found
}

static bool load_input_libraries(LinkContext& context,
                                 const std::vector<std::string>& libraries,
                                 const std::vector<std::string>& library_paths) {
    for (auto& libname : libraries) {
        std::string resolved_path = resolve_library_path(libname, library_paths);

        if (resolved_path.empty()) {
            g_diag.error(SourceLoc(), "Library not found: " + libname);
            return false;
        }

        auto obj_lib = std::make_unique<ObjectLibrary>();
        if (!read_object_library(*obj_lib, resolved_path)) {
            return false;   // error already reported
        }

        context.libraries.push_back(std::move(obj_lib));
    }

    return true;
}

static void build_library_index(LinkContext& context) {
    for (auto& lib : context.libraries) {
        for (auto& mod : lib->modules) {
            for (auto& sym : mod.symbols) {
                if (sym.scope == ObjSymbolScope::Public) {
                    uint sym_id = g_strings.intern(sym.name());
                    if (context.symbol_to_module.count(sym_id) == 0) {
                        context.symbol_to_module[sym_id] = &mod;
                    }
                }
            }
        }
    }
}

void link_files(const std::vector<std::string>& filenames,
                const std::vector<std::string>& libraries,
                const std::vector<std::string>& library_paths,
                std::string_view output_dir) {
    auto context = std::make_unique<LinkContext>();

    // load input object files
    if (!load_input_modules(*context, filenames, output_dir)) {
        return; // error already reported
    }

    // load input libraries
    if (!load_input_libraries(*context, libraries, library_paths)) {
        return; // error already reported
    }

    // build library index
    build_library_index(*context);

}
#endif
