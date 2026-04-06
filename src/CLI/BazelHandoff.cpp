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
};

std::string make_workspace_path(const char *workspace_root, const char *relative_path)
{
    std::string path = workspace_root;
    if (!path.empty() && path.back() != '/')
        path.push_back('/');
    path += relative_path;
    return path;
}

} // namespace

namespace Slic3r::CLI {

int run(int argc, char **argv)
{
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
        fprintf(stderr,
                "Bazel handoff seam could not find an executable PrusaSlicer binary in build/src/Debug.\n");
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
