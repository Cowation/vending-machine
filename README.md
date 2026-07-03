# Vending Machine

Basic Verilog vending machine design with Vivado simulation/project scripts and a
Yosys-based gate synthesis flow.

## Setup

Install Xilinx Vivado and make sure the `vivado` command is available from your
terminal if you want to use the Vivado project or simulation flow.

Install Yosys, or a package that includes it such as OSS CAD Suite, if you want
to run the open-source synthesis flow. The `yosys` command must be available
from the terminal, or passed to `make` with `YOSYS=/path/to/yosys`.

Create or refresh the Vivado project:

```sh
make vivado-project
```

This generates the Vivado project under `build/vivado/`.

To open the generated project in the Vivado GUI:

```sh
make vivado-gui
```

If Vivado is not on your `PATH`, pass the executable path to `make`:

```sh
make VIVADO=/path/to/vivado vivado-project
```

Similarly, if Yosys is not on your `PATH`, pass the executable path to `make`:

```sh
make YOSYS=/path/to/yosys yosys-synth
```

## Adding or Editing Source Files

Design sources go in `rtl/`. Testbench sources go in `tb/`.

After adding a new source file, add its path to the matching file list:

- `filelists/rtl.f` for design files
- `filelists/tb.f` for testbench files

Paths in the file lists are relative to the file list location. For example:

```text
../rtl/top.v
../tb/top_tb.v
```

The Vivado setup script currently expects the design top module to be `top` and the simulation top module to be `top_tb`. If those names change, update `scripts/vivado/create_project.tcl`.

## Standard Cell Library

The project includes a small dummy standard-cell library under
`lib/knoddy_std/` for Yosys experiments:

- `lib/knoddy_std/verilog/knoddy_std.v` contains behavioral Verilog models for
  `INV_X1`, `BUF_X1`, `NAND2_X1`, `NOR2_X1`, and `DFF_X1`.
- `lib/knoddy_std/liberty/knoddy_std.lib` contains rough Liberty timing, area,
  and pin definitions for those same cells.

The Liberty data is intentionally approximate. It is good enough for local
technology mapping and toy area estimates, not signoff timing.

## Running Simulation

Run behavioral simulation in batch mode:

```sh
make sim
```

The simulation script creates the Vivado project, launches behavioral simulation, runs it, and exits.

The testbench in `tb/top_tb.v` checks the vending-machine behavior, including
the synchronous reset expectation: asserting `grst` between clock edges should
not change state until the next rising edge of `clk`.

## Running Yosys Synthesis

Run the Yosys gate synthesis flow:

```sh
make yosys-synth
```

This runs `scripts/yosys/synth_top.ys`, which:

- reads the RTL files under `rtl/`
- uses `top` as the design top
- flattens the design
- maps sequential logic to `DFF_X1`
- maps combinational logic through ABC using `knoddy_std.lib`
- writes the synthesized gate-level netlist to `build/yosys/top_gate.v`

The generated netlist is build output and is ignored by Git through the
existing `build/` ignore rule.

To remove generated build and simulation output:

```sh
make clean
```

## License

This project is licensed under the GNU Affero General Public License v3.0 or later. See `LICENSE` for the full license text.
