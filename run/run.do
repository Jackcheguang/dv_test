# ModelSim 运行脚本
# 使用方式: vsim -do run/run.do

# 创建 work 库
vlib work
vmap work work

# 编译 RTL
vlog -sv ../rtl/adder.v

# 编译 UVM 库 (如果需要)
vlog -sv $env(UVM_HOME)/src/uvm.sv

# 编译接口和 UVM 组件
vlog -sv ../uvm_lib/interfaces.sv
vlog -sv ../uvm_lib/transaction.sv
vlog -sv ../uvm_lib/sequencer.sv
vlog -sv ../uvm_lib/sequences.sv
vlog -sv ../uvm_lib/driver.sv
vlog -sv ../uvm_lib/monitor.sv
vlog -sv ../uvm_lib/scoreboard.sv
vlog -sv ../uvm_lib/env.sv
vlog -sv ../uvm_lib/test.sv

# 编译 Testbench
vlog -sv ../tb/top.sv

# 仿真
vsim -voptargs="+acc" work.top

# 显示波形
add wave -recursive *

# 运行仿真
run -all

# 退出
quit