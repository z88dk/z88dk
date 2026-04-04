//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "pathnames.h"
#include "string_utils.h"
#include <filesystem>

// On Linux, lexically_normal() does not regard backslashes as path separators
static std::string nomalize_slashes(std::string_view path) {
    std::string result;
    result.reserve(path.size());
    for (auto c : path) {
        if (c == '\\') {
            result.push_back('/');
        }
        else {
            result.push_back(c);
        }
    }
    return result;
}

bool is_asm_filename(std::string_view filename) {
    return ends_with(filename, asm_extension);
}

bool is_o_filename(std::string_view filename) {
    return ends_with(filename, o_extension);
}

std::string get_asm_filename(std::string_view filename) {
    return replace_extension(filename, asm_extension);
}

std::string get_o_filename(std::string_view filename,
                           std::string_view output_dir) {
    return prepend_output_dir(replace_extension(filename, o_extension), output_dir);
}

std::string normalize_path(std::string_view path_) {
    std::string path = nomalize_slashes(path_);

    if (path.empty()) {
        return ".";
    }

    // Preserve UNC prefix: if original path starts with // or \\,
    // ensure the normalized result also starts with a double slash.
    const bool had_unc_prefix = starts_with(path, "//");

    try {
        std::filesystem::path p(path);
        std::string result = p.lexically_normal().generic_string();

        if (had_unc_prefix) {
            // If normalization collapsed the leading // to / (or removed it),
            // put it back so UNC paths are preserved consistently across platforms.
            if (!starts_with(result, "//")) {
                if (starts_with(result, "/")) {
                    result = "/" + result;  // make it begin with "//"
                }
                else {
                    result = "//" + result; // add full UNC prefix if missing
                }
            }
        }
        return result;
    }
    catch (...) {
        return path;
    }
}

std::string parent_dir(std::string_view path) {
    try {
        std::filesystem::path p(nomalize_slashes(path));
        return p.parent_path().generic_string();
    }
    catch (...) {
        return std::string();
    }
}

std::string replace_extension(std::string_view filename,
                              std::string_view extension) {
    try {
        std::filesystem::path p(filename);
        p.replace_extension(extension);
        return normalize_path(p.lexically_normal().generic_string());
    }
    catch (...) {
        return normalize_path(std::string(filename) + std::string(extension));
    }
}

std::string prepend_output_dir(std::string_view filename,
                               std::string_view output_dir_) {
    namespace fs = std::filesystem;

    std::string output_dir(output_dir_);

    if (output_dir.empty()) {
        return normalize_path(filename);
    }
    else if (filename.substr(0, output_dir.size() + 1) == output_dir + "/") {
        // #2260: may be called with an object file already with
        // the path prepended; do not add it twice
        return normalize_path(filename);
    }
    else {
        // NOTE: concatenation (/) of a relative fs::path and an
        // absolute fs::path discards the first one! Do our magic
        // with strings instead.

        // is it a win32 absolute path?
        std::string file;
        if (filename.size() >= 2 && is_alpha(filename[0]) && filename[1] == ':') {	// C:
            file += output_dir + "/";
            file += std::string(1, filename[0]) + "/";
            file += std::string(filename.substr(2));
        }
        else {
            file += output_dir + "/";
            file += filename;
        }
        fs::path path{ file };
        return normalize_path(path.lexically_normal().generic_string());
    }
}

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
// including_filename: the file which contains the include directive (can be empty if unknown)
std::string resolve_include_candidate(std::string_view filename,
                                      std::string_view including_filename, bool is_angle,
                                      const std::vector<std::string>& include_paths) {
    namespace fs = std::filesystem;

    std::vector<fs::path> candidates;

    fs::path fname(filename);

    // If the filename is absolute, try it directly
    if (fname.is_absolute()) {
        candidates.push_back(fname);
    }
    else {
        // Determine including file directory, if provided
        std::string including_dir = parent_dir(including_filename);
        if (including_dir.empty()) {
            including_dir = ".";
        }

        if (!is_angle) {
            // Quoted or plain include: try including file directory first (if known)
            if (!including_dir.empty()) {
                candidates.push_back(fs::path(including_dir) / fname);
            }
            // Then user-provided include paths
            for (const auto& p : include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            // Finally as-given (relative to current working dir of the process)
            candidates.push_back(fname);
        }
        else {
            // Angle includes: search include paths, then as-given
            for (const auto& p : include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            candidates.push_back(fname);
        }
    }

    // check candidates
    for (const auto& c : candidates) {
        try {
            fs::path norm = c;
            // Do not require file to be accessible by canonical
            // (it may throw), use exists
            if (fs::exists(norm) && fs::is_regular_file(norm)) {
                try {
                    return normalize_path(norm.lexically_normal().generic_string());
                }
                catch (...) {
                    return normalize_path(norm.generic_string());
                }
            }
        }
        catch (...) {
            // ignore path errors and move on
        }
    }

    return std::string();
}

bool has_wildcards(std::string_view pat) {
    return pat.find('*') != std::string::npos ||
           pat.find('?') != std::string::npos;
}

// Helper: split a path string into components, preserving "**" segments
static std::vector<std::string> split_path_components(
    std::string_view path) {
    std::vector<std::string> comps;
    std::string cur;
    for (char c : path) {
        if (c == '/' || c == '\\') {
            if (!cur.empty()) {
                comps.push_back(cur);
                cur.clear();
            }
        }
        else {
            cur.push_back(c);
        }
    }
    if (!cur.empty()) {
        comps.push_back(cur);
    }
    return comps;
}

// Helper: match a single name with '*' and '?' wildcards (non-recursive, no directory separators)
static bool match_name_glob(std::string_view name, std::string_view pat) {
    size_t n = name.size(), p = pat.size();
    size_t i = 0, j = 0;
    size_t star_i = std::string::npos, star_j = std::string::npos;

    while (i < n) {
        if (j < p && (pat[j] == '?' || pat[j] == name[i])) {
            ++i;
            ++j;
        }
        else if (j < p && pat[j] == '*') {
            star_j = j++;
            star_i = i;
        }
        else if (star_j != std::string::npos) {
            j = star_j + 1;
            i = ++star_i;
        }
        else {
            return false;
        }
    }
    while (j < p && pat[j] == '*') {
        ++j;
    }
    return j == p;
}

// Helper: recursive matcher over path components supporting "**"
// for subdirectory sequences.
// anchor keeps the textual base path as given by the pattern prefix,
// so results remain relative
static void glob_walk(const std::filesystem::path& base_fs,
                      const std::filesystem::path& anchor,
                      const std::vector<std::string>& comps,
                      size_t idx,
                      std::vector<std::filesystem::path>& out) {
    namespace fs = std::filesystem;

    if (idx == comps.size()) {
        // terminal: record files only (regular_file) using the anchor to preserve relativeness
        if (fs::exists(base_fs) && fs::is_regular_file(base_fs)) {
            out.push_back(anchor.lexically_normal().generic_string());
        }
        return;
    }

    std::string_view pat = comps[idx];

    if (pat == "**") {
        // "**" consumes zero or more directory levels
        // 1) zero levels: continue matching next component at current base
        glob_walk(base_fs, anchor, comps, idx + 1, out);

        // 2) recurse into all subdirectories
        if (fs::exists(base_fs) && fs::is_directory(base_fs)) {
            std::error_code ec;
            for (fs::recursive_directory_iterator it(base_fs, ec), end; it != end; ++it) {
                if (ec) {
                    break;
                }
                if (it->is_directory()) {
                    // compute relative subdir path to append to anchor
                    std::error_code ec2;
                    fs::path rel = fs::relative(it->path(), base_fs, ec2);
                    if (ec2) {
                        rel = it->path().filename();
                    }
                    glob_walk(it->path(), anchor / rel, comps, idx + 1, out);
                }
            }
        }
        return;
    }

    // normal component (with '*'/'?' wildcards) matched against entries in current directory
    if (!fs::exists(base_fs) || !fs::is_directory(base_fs)) {
        // Not a directory: nothing to do here (wildcard cannot match)
        return;
    }

    std::error_code ec;
    for (fs::directory_iterator it(base_fs, ec), end; it != end; ++it) {
        if (ec) {
            break;
        }
        const std::string name = it->path().filename().string();
        if (!match_name_glob(name, pat)) {
            continue;
        }

        if (idx == comps.size() - 1) {
            // last component: collect files only, keep relative anchor + filename
            if (it->is_regular_file()) {
                out.push_back((anchor /
                               it->path().filename()).lexically_normal().generic_string());
            }
        }
        else {
            // continue with next component; advance both filesystem and textual anchors
            glob_walk(it->path(), anchor / it->path().filename(), comps, idx + 1, out);
        }
    }
}

// Expand wildcards using std::filesystem only: supports '*', '?', and '**'
std::vector<std::string> expand_wildcards(std::string_view pattern) {
    namespace fs = std::filesystem;

    std::vector<std::string> results;

    // If no wildcards, return as-is (normalized)
    if (!has_wildcards(pattern)) {
        results.push_back(normalize_path(pattern));
        return results;
    }

    // Split pattern into components preserving "**"
    std::vector<std::string> comps = split_path_components(pattern);

    // Build non-wildcard prefix as base (textual) until first wildcard segment
    fs::path base_prefix;
    size_t wildcard_idx = 0;
    for (; wildcard_idx < comps.size(); ++wildcard_idx) {
        std::string_view seg = comps[wildcard_idx];
        const bool seg_has_wildcard = (seg == "**") ||
                                      seg.find('*') != std::string::npos ||
                                      seg.find('?') != std::string::npos;
        if (seg_has_wildcard) {
            break;
        }

        if (base_prefix.empty()) {
            base_prefix = fs::path(seg);
        }
        else {
            base_prefix /= seg;
        }
    }

    // Filesystem base for walking; if no prefix, use "." (current directory) but keep anchor empty
    fs::path base_fs = base_prefix.empty() ? fs::path(".") : base_prefix;
    fs::path anchor =
        base_prefix; // textual anchor as given by the pattern prefix (may be relative)

    // Remaining components to match from the first wildcard segment
    std::vector<std::string> rest(comps.begin() + wildcard_idx, comps.end());

    // Walk and collect; ensure we keep relative paths based on the pattern prefix (anchor)
    std::vector<fs::path> paths;
    glob_walk(base_fs, anchor, rest, 0, paths);

    for (const auto& ph : paths) {
        try {
            results.push_back(ph.lexically_normal().generic_string());
        }
        catch (...) {
            results.push_back(ph.generic_string());
        }
    }

    return results;
}

