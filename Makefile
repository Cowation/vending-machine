VIVADO ?= vivado
YOSYS ?= yosys

.PHONY: vivado-project vivado-gui sim yosys-synth clean

vivado-project:
	$(VIVADO) -mode batch -source scripts/vivado/create_project.tcl

vivado-gui: vivado-project
	$(VIVADO) build/vivado/vending-machine.xpr

sim:
	$(VIVADO) -mode batch -source scripts/vivado/sim.tcl

yosys-synth:
	mkdir -p build/yosys
	$(YOSYS) -s scripts/yosys/synth_top.ys

clean:
	rm -rf build .Xil xsim.dir *.jou *.log *.str *.wdb
