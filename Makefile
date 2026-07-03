VIVADO ?= vivado

.PHONY: vivado-project vivado-gui sim clean

vivado-project:
	$(VIVADO) -mode batch -source scripts/vivado/create_project.tcl

vivado-gui: vivado-project
	$(VIVADO) build/vivado/my_chip_vivado.xpr

sim:
	$(VIVADO) -mode batch -source scripts/vivado/sim.tcl

clean:
	rm -rf build .Xil xsim.dir *.jou *.log *.str *.wdb