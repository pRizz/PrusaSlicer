#include "PrusaSlicer.hpp"

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

#include <string>
#include <vector>

namespace {

const char *candidate_binary_paths[] = {
    "build/src/Debug/PrusaSlicer",
    "build/src/Debug/prusa-slicer",
    "build/src/PrusaSlicer",
    "build/src/prusa-slicer",
};

std::string make_workspace_path(const char *workspace_root, const char *relative_path) {
    std::string path = workspace_root;
    if (!path.empty() && path.back() != '/')
        path.push_back('/');
    path += relative_path;
    return path;
}

bool wants_help(int argc, char **argv) {
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0)
            return true;
    }

    return false;
}

void print_bazel_help() {
    puts("PrusaSlicer Bazel Phase 3 proof slice");
    puts("");
    puts("This Bazel-owned seam handles `--help` directly while later Phase 3");
    puts("waves deepen the owned CLI/core slice behind the same //src:PrusaSlicer label.");
    puts("");
    puts("Current behavior:");
    puts("- `--help` and `-h` are served directly by the Bazel-owned CLI seam");
    puts("- other arguments still hand off to the locally built legacy PrusaSlicer binary");
}

} // namespace

namespace Slic3r::CLI {

int run(int argc, char **argv) {
    if (wants_help(argc, argv)) {
        print_bazel_help();
        return 0;
    }

    const char *binary = nullptr;
    std::string resolved_path;
    const char *workspace_root = getenv("BUILD_WORKSPACE_DIRECTORY");

    for (const char *path : candidate_binary_paths) {
        if (workspace_root != nullptr) {
            resolved_path = make_workspace_path(workspace_root, path);
            if (access(resolved_path.c_str(), X_OK) == 0) {
                binary = resolved_path.c_str();
                break;
            }
        }

        if (access(path, X_OK) == 0) {
            binary = path;
            break;
        }
    }

    if (binary == nullptr) {
        fprintf(
            stderr, "Bazel handoff seam could not find an executable legacy PrusaSlicer binary in build/src.\n"
        );
        return 1;
    }

    std::vector<char *> forwarded;
    forwarded.reserve(static_cast<size_t>(argc) + 1);
    forwarded.push_back(const_cast<char *>(binary));
    for (int i = 1; i < argc; ++i)
        forwarded.push_back(argv[i]);
    forwarded.push_back(nullptr);

    execv(binary, forwarded.data());

    fprintf(stderr, "Failed to exec %s: %s\n", binary, strerror(errno));
    return errno == 0 ? 1 : errno;
}

} // namespace Slic3r::CLI
