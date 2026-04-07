
![PrusaSlicer logo](/resources/icons/PrusaSlicer.png?raw=true)

# PrusaSlicer

[![GitHub Stars](https://img.shields.io/github/stars/pRizz/PrusaSlicer)](https://github.com/pRizz/PrusaSlicer)

You may want to check the [PrusaSlicer project page](https://www.prusa3d.com/prusaslicer/).
Prebuilt Windows, OSX and Linux binaries are available through the [git releases page](https://github.com/prusa3d/PrusaSlicer/releases) or from the [Prusa3D downloads page](https://www.prusa3d.com/drivers/). There are also [3rd party Linux builds available](https://github.com/prusa3d/PrusaSlicer/wiki/PrusaSlicer-on-Linux---binary-distributions).

PrusaSlicer takes 3D models (STL, OBJ, AMF) and converts them into G-code
instructions for FFF printers or PNG layers for mSLA 3D printers. It's
compatible with any modern printer based on the RepRap toolchain, including all
those based on the Marlin, Prusa, Sprinter and Repetier firmware. It also works
with Mach3, LinuxCNC and Machinekit controllers.

PrusaSlicer is based on [Slic3r](https://github.com/Slic3r/Slic3r) by Alessandro Ranellucci and the RepRap community.

See the [project homepage](https://www.prusa3d.com/slic3r-prusa-edition/) and
the [documentation directory](doc/) for more information.

### Bazel-first front door

The repository is moving to a Bazel-first local workflow. The supported root
entry point is `./prusa`, with the direct Bazel equivalent shown for each
action:

```shell
./prusa build --dry-run
# bazel build --config=dev --config=<platform> //...

./prusa test --platform macos --dry-run
# bazel test --config=dev --config=macos //tools/bazel:test_suite

./prusa test --platform linux --dry-run
# bazel test --config=dev --config=linux //tools/bazel:test_suite

./prusa fmt --check --dry-run
# bazel run --config=dev //tools/bazel/format:check

./prusa fmt --fix --dry-run
# bazel run --config=dev //tools/bazel/format:fix

./prusa lint --dry-run
# bazel run --config=dev //tools/bazel/lint:clang_tidy

./prusa compdb --dry-run
# bazel build --config=dev --config=compdb //tools/bazel:compdb
```

Current bounded Phase 4 local test surface:
- `//tools/bazel:test_suite`
- `//tests/libslic3r:config_test`
- `//tests/thumbnails:thumbnails_test`

This is the authoritative non-GUI smoke-plus-regression test surface for the
Bazel path right now. It is intentionally not full legacy CTest parity.

Tracked legacy test exceptions still remain under CMake/CTest for broader
surfaces such as `tests/fff_print`, `tests/sla_print`, `tests/slic3rutils`,
`tests/arrange`, and the larger `tests/libslic3r` suite while the Bazel graph
expands.

On a macOS host, `./prusa test --platform linux` runs the same bounded Bazel
suite inside Docker so the Linux label stays visible without pretending
host-side cross-platform toolchains already exist.

Current bounded Phase 4 formatting surface:
- `src/BazelMain.cpp`
- `src/CLI/BazelHandoff.cpp`
- `src/libslic3r/BazelConfigCompat.cpp`
- `tests/libslic3r/{BazelCatchMain.cpp,test_config.cpp}`
- `tests/thumbnails/*.cpp`

Tracked formatting exclusions still include the inherited proof-slice core
translation units in `src/libslic3r/{BoundingBox.cpp,Config.cpp,Point.cpp,PrintConfig.cpp}`,
plus `tests/fff_print`, `tests/sla_print`, `tests/slic3rutils`,
`tests/arrange`, and the broader GUI and packaging-heavy source tree outside
the migrated proof slice.

Current bounded Phase 4 lint surface:
- `src/BazelMain.cpp`
- `src/CLI/BazelHandoff.cpp`
- `src/libslic3r/BazelConfigCompat.cpp`
- `tests/libslic3r/BazelCatchMain.cpp`
- `tests/thumbnails/*.cpp`

Tracked lint deferrals currently include broader readability/modernization work,
the inherited proof-slice core translation units in `src/libslic3r`, and the
current Catch-heavy `tests/libslic3r/test_config.cpp`, plus the GUI, packaging,
and larger CTest-only suites outside the migrated proof slice.

The existing platform-specific CMake build guides remain available below as
legacy transition documentation while the Bazel graph is expanded.

### What language is it written in?

All user facing code is written in C++.
The slicing core is the `libslic3r` library, which can be built and used in a standalone way.
The command line interface is a thin wrapper over `libslic3r`.

### What are PrusaSlicer's main features?

Key features are:

* **multi-platform** (Linux/Mac/Win) and packaged as standalone-app with no dependencies required
* complete **command-line interface** to use it with no GUI
* multi-material **(multiple extruders)** object printing
* multiple G-code flavors supported (RepRap, Makerbot, Mach3, Machinekit etc.)
* ability to plate **multiple objects having distinct print settings**
* **multithread** processing
* **STL auto-repair** (tolerance for broken models)
* wide automated unit testing

Other major features are:

* combine infill every 'n' perimeters layer to speed up printing
* **3D preview** (including multi-material files)
* **multiple layer heights** in a single print
* **spiral vase** mode for bumpless vases
* fine-grained configuration of speed, acceleration, extrusion width
* several infill patterns including honeycomb, spirals, Hilbert curves
* support material, raft, brim, skirt
* **standby temperature** and automatic wiping for multi-extruder printing
* [customizable **G-code macros**](https://github.com/prusa3d/PrusaSlicer/wiki/PrusaSlicer-Macro-Language) and output filename with variable placeholders
* support for **post-processing scripts**
* **cooling logic** controlling fan speed and dynamic print speed

### Development

If you want to compile the source yourself, follow the instructions on one of
these documentation pages:
* [Linux](doc/How%20to%20build%20-%20Linux%20et%20al.md)
* [macOS](doc/How%20to%20build%20-%20Mac%20OS.md)
* [Windows](doc/How%20to%20build%20-%20Windows.md)

### Can I help?

Sure! You can do the following to find things that are available to help with:
* Add an [issue](https://github.com/prusa3d/PrusaSlicer/issues) to the github tracker if it isn't already present.
* Look at [issues labeled "volunteer needed"](https://github.com/prusa3d/PrusaSlicer/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+label%3A%22volunteer+needed%22)

### What's PrusaSlicer license?

PrusaSlicer is licensed under the _GNU Affero General Public License, version 3_.
The PrusaSlicer is originally based on Slic3r by Alessandro Ranellucci.

### How can I use PrusaSlicer from the command line?

Please refer to the [Command Line Interface](https://github.com/prusa3d/PrusaSlicer/wiki/Command-Line-Interface) wiki page.
