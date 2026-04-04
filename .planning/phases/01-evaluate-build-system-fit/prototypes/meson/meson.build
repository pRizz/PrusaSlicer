project(
  'prusaslicer_phase1_eval',
  'cpp',
  version: '0.1.0',
  default_options: ['cpp_std=c++17', 'warning_level=2']
)

cpp = meson.get_compiler('cpp')

phase1_includes = include_directories(
  'src',
  'src/CLI',
  'tests',
)

prusaslicer_cli_eval = executable(
  'prusaslicer_cli_eval',
  [
    'src/PrusaSlicer.cpp',
    'src/CLI/Run.cpp',
    'src/CLI/Setup.cpp',
  ],
  include_directories: phase1_includes,
  cpp_args: ['-DSLIC3R_GUI=0'],
  install: false,
)

libslic3r_core_eval_test = executable(
  'libslic3r_core_eval_test',
  [
    'tests/libslic3r/test_config.cpp',
  ],
  include_directories: phase1_includes,
  install: false,
)

test(
  'libslic3r_core_eval_test',
  libslic3r_core_eval_test,
)

# Phase 1 note:
# This prototype intentionally omits the full external dependency closure.
# The goal is to expose how naturally Meson can express the selected slice,
# not to perform full migration work inside the evaluation phase.
