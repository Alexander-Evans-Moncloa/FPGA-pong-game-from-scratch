# FPGA Pong Game and Custom CPU Design  

## Overview  
This repository contains the design and implementation of a fully functional computer from scratch using an FPGA, programmed in SystemVerilog. The project culminates in running the classic game Pong, displayed on a VGA monitor. It demonstrates expertise in digital systems design, low-level hardware development, and optimisation of computational architecture.  

## Project Description  
This project showcases the development of a custom CPU designed entirely from scratch, including its key components such as the Arithmetic Logic Unit (ALU), Program Counter (PC), Register File, and VGA Controller. The design was implemented on an FPGA platform, programmed using SystemVerilog. The CPU's architecture and logic were meticulously designed to execute basic operations and interface with external peripherals such as a VGA display.  

The final achievement was running a fully functional Pong game, rendered in real-time on a VGA-connected monitor. This project highlights the integration of hardware modules and the synchronisation of digital circuits to achieve a robust and optimised computer system.  

## Key Features  
- **Custom CPU Design:**  
  Designed the architecture and logic of a CPU from scratch, including components such as the ALU, control unit, program counter, and registers.  

- **SystemVerilog Programming:**  
  Leveraged SystemVerilog to program the FPGA, enabling the development of complex logic circuits and modules. Comprehensive test benches were created to validate the functionality of individual components and the overall system.  

- **VGA Display Interface:**  
  Implemented a VGA controller to generate video signals for rendering the Pong game on a monitor. This included managing pixel generation, synchronisation, and video timing.  

- **Hardware Optimisation:**  
  Minimised FPGA resource utilisation while maintaining functional integrity through careful design and optimisation of CPU components.  

- **Game Implementation:**  
  Successfully programmed the Pong game to run on the custom-built CPU, demonstrating the system’s capability to interface with peripherals and execute real-time operations.  

## Technologies and Tools  
- **FPGA Platform:**  
  Used as the target hardware for prototyping and implementing the custom CPU design.  

- **SystemVerilog:**  
  Hardware Description Language (HDL) used to design, simulate, and test all components of the system.  

- **CPU Architecture:**  
  Designed and implemented from scratch, including an ALU, register file, program counter, and control unit.  

- **Test Benches:**  
  Comprehensive test benches were developed to simulate each module and verify the overall system performance.  

- **VGA Display:**  
  Integrated a VGA interface for visual output, enabling real-time game rendering and synchronisation.  

## Directory Structure  
- **ArithmeticLogicUnit:** Contains the design files for the ALU module.  
- **HighRiscSystem:** Includes the main system files integrating the CPU and peripherals.  
- **PongGame:** Contains the logic and modules used to implement the Pong game.  
- **ProgramCounter:** Program Counter logic design files.  
- **RegisterFile:** Design files for the Register File module.  
- **VGAController:** VGA interface design files for generating the game display.  
- **README.md:** Project overview and description.  

## Getting Started  
1. Clone this repository:  
   ```bash  
   git clone https://github.com/yourusername/FPGA-pong-game-from-scratch.git  
