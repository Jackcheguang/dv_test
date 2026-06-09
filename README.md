# UVM加法器验证环境

这是一个基于UVM(Universal Verification Methodology)框架搭建的加法器验证环境。

## 项目结构

```
dv_test/
├── rtl/                    # RTL设计文件
│   └── adder.v            # 8位加法器设计
├── tb/                    # 测试平台
│   └── top.sv             # 顶层仿真模块
├── uvm_lib/               # UVM验证组件
│   ├── interfaces.sv      # 接口定义
│   ├── transaction.sv     # Transaction类
│   ├── sequencer.sv       # Sequencer类
│   ├── sequences.sv       # Sequence类集合
│   ├── driver.sv          # Driver驱动类
│   ├── monitor.sv         # Monitor监听类
│   ├── scoreboard.sv      # 记分板类
│   ├── env.sv             # 环境类
│   └── test.sv            # 测试类
└── run/                   # 仿真运行脚本
    └── run.do            # ModelSim运行脚本
```

## 验证环境组件说明

### 1. Transaction (transaction.sv)
- 定义了加法器的事务对象
- 包含输入信号(a, b)和输出信号(sum, valid)

### 2. Driver (driver.sv)
- 从Sequencer获取Transaction
- 将事务数据驱动到DUT接口

### 3. Monitor (monitor.sv)
- 监听DUT的输出
- 通过analysis port将监听到的事务发送给Scoreboard

### 4. Scoreboard (scoreboard.sv)
- 接收Monitor发来的事务
- 与预期结果进行比较
- 记录通过/失败的测试数

### 5. Sequencer (sequencer.sv)
- 协调Driver和Sequence
- 管理事务流

### 6. Sequences (sequences.sv)
- **adder_sequence**: 随机测试序列，产生10个随机测试向量
- **adder_directed_sequence**: 定向测试序列，测试边界情况

### 7. Environment (env.sv)
- 实例化所有验证组件
- 连接各组件的接口和通路

### 8. Test (test.sv)
- **adder_base_test**: 基础测试基类
- **adder_random_test**: 随机测试用例
- **adder_directed_test**: 定向测试用例

## 使用说明

### 前置条件
- 已安装 ModelSim/QuestaSim 或其他 SystemVerilog 仿真器
- 已配置 UVM 库的路径

### 运行仿真

**使用 ModelSim:**
```bash
cd run
modelsim -do run.do
```

**或使用命令行:**
```bash
vlib work
vlog -sv ../uvm_lib/*.sv ../rtl/*.v ../tb/*.sv
vsim work.top -do "run -all; quit"
```

### 运行特定测试
```bash
vsim work.top -g UVM_TESTNAME=adder_random_test
```

或

```bash
vsim work.top -g UVM_TESTNAME=adder_directed_test
```

## 验证结果

仿真完成后，检查 transcript 文件查看：
- `PASS`: 通过的测试数
- `FAIL`: 失败的测试数
- 每个事务的详细信息

## 扩展建议

1. **添加覆盖率收集**
   - 在 Transaction 中添加 covergroup
   - 收集功能覆盖率信息

2. **添加约束**
   - 在 Transaction 中添加 constraints
   - 实现更加精准的随机测试

3. **添加功能覆盖率收集器**
   - 创建专门的覆盖率收集类
   - 跟踪测试覆盖度

4. **支持更复杂的DUT**
   - 扩展接口以支持流控(ready/valid)
   - 添加更多的输入输出端口

## 参考资源

- [UVM 1.2 标准参考](https://www.accellera.org/downloads/standards/uvm/)
- SystemVerilog Language Reference
- 验证方法学最佳实践

## 许可证

MIT License
