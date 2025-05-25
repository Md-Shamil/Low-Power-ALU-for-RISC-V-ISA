# Low-Power-ALU-for-RISC-V-ISA

A VLSI Systems Design project aiming to minimize power consumption in ALUs using Verilog.

This project explores low-power ALU design strategies for RISC-V architecture by comparing three implementations. The latch-based ALU achieved the most efficient power performance with a 38.60 mW reduction over conventional design.

## 📘 Description

This project compares the performance of:
- Standard ALU
- Resource Sharing ALU
- Latch-Based ALU

All modules are implemented in Verilog, tested in Icarus Verilog, and power-analyzed using Quartus II.

### 🔎 Objective

Reduce thermal power dissipation using:
- Resource sharing of components
- Latches with enable signal control
- Power gating mechanisms

### 🧪 ALU Operations Covered

- Addition
- Subtraction
- AND, OR, XOR, NOT
- Comparisons

### 🧪 Block Diagrams

**Customized 1-bit Full Adder**  
![Customized 1-bit Full Adder](https://github.com/user-attachments/assets/24ab4e19-bd39-4ad7-89ee-7e45276bb40b)

**Resource-Sharing Technique**  
![Resource-Sharing Technique](https://github.com/user-attachments/assets/8025cf80-b6b9-4516-93cc-26eb5ba09934)

**Latch-Based Technique**  
![Latch-Based Technique](https://github.com/user-attachments/assets/8861cfbe-a35a-490b-97d4-12f271d19ace)

**Proposed ALU**  
![Proposed ALU](https://github.com/user-attachments/assets/1bf2a72f-a829-4e16-9b80-4ec170d44919)


### 🧪 Simulation Results

**Power Analysis of Conventional ALU**  
![Power Analysis of Conventional ALU](https://github.com/user-attachments/assets/e6c66328-9020-4d4a-aec3-64b7e5903058)

**Power Analysis of Resource-Sharing Technique Based ALU**  
![Power Analysis of Resource-Sharing ALU](https://github.com/user-attachments/assets/41bf34cd-4627-40af-8b7f-db98dc9b15cc)

**Power Analysis of Latch Technique Based ALU**  
![Power Analysis of Latch Technique Based ALU](https://github.com/user-attachments/assets/f1dbbada-44ad-4bf1-b3f1-1ed9b766da3f)

**Verification of Resource-Sharing Technique Based ALU**  
![Verification of Resource-Sharing Technique Based ALU](https://github.com/user-attachments/assets/2bc7642b-cf99-4136-9e34-76c076b50f2e)

**Verification of Latch Technique Based ALU**  
![Verification of Latch Technique Based ALU](https://github.com/user-attachments/assets/76112bf6-444f-4ac6-a0bc-d5ddcec258a5)

**Proposed ALU Along with Latch-Based and Resource-Sharing Techniques – View 1**  
![Proposed ALU View 1](https://github.com/user-attachments/assets/d12c9772-5478-41c7-9347-9d7a7c3d7410)

**Proposed ALU Along with Latch-Based and Resource-Sharing Techniques – View 2**  
![Proposed ALU View 2](https://github.com/user-attachments/assets/f07fde62-b2f0-4001-adf0-bea1f735fa4c)




### 🔋 Power Analysis Summary

| Type              | Power (mW) |
|-------------------|------------|
| Normal ALU        | 104.53     |
| Resource Sharing  | 104.40     |
| Latch-Based ALU   | 64.93 🔥   |

> ✅ Latch-Based ALU is most efficient!

## 💡 Highlights

- 🔌 Power-efficient latch techniques
- ♻️ Shared logic reuse
- 📊 Verified simulation results
- 🔐 Enable signal control

## 🛠️ Tech Stack

- Verilog (Icarus Verilog)
- Quartus II (Power simulation)
- VS Code (Development)


---

