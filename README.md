# Abacus 2 Project
*Abacus 2 Processor and Carbon 1 System*

## Specifications

- Processor: Abacus 2
- Bus Width: 16 Bits
- Speed: 1 MHz ≤ 8 MHz
- Memory: 4 KB ≤ 16 MB

## Design Showcase

### System Architecture

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/z00.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/c07.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/c04.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/c01.JPG)

### Instruction Set

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/i03.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/i01.JPG)

### Memory and I/O

### Interrupt Handling

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/interrupts/v01.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/interrupts/i04.JPG)

### Video Output

### System Firmware

![](https://github.com/Julesc013/abacus-2/blob/main/software/bios/m00.JPG)

## Physical Case

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/case/s00.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/case/s01.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/case/s02.JPG)

## User Manual

## Directory Structure
```
├── archive             Archived and old versions of files.
├── hardware            Hardware design and circuitry.
│   ├── cassette            Cassette tape data storage.
│   ├── chipset             Northbridge, southbridge, I/O, wait states, etc.
│   ├── floppy              Floppy diskette data storage.
│   ├── instructions        Instruction set architecture.
│   ├── interrupts          Interrupt tables and circuits.
│   ├── memory              Memory maps, wait states, DMA, etc.
│   ├── printer             Parallel ports and printer communication.
│   ├── serial              Serial ports and teletype communication.
│   ├── todo                Todo lists and general notes.
│   └── video               Video text and graphics output.
├── info                General project information and metadata.
│   ├── datasheets          Relevant datasheets.
│   ├── manual              User and technical manuals for the system.
│   └── parts               Parts lists and records.
├── schematics          Schematics and technical drawings.
├── simulation          Virtual simulation of processor.
│   ├── digital             Implementation in Digital.
│   └── logisim             Implementation in Logisim Evolution.   
└── software            Software, firmware, drivers, operating systems, etc.
    ├── assembler           Assembler and linker.
    ├── basic               Implementation of Microsoft 8K BASIC.
    ├── bios                Disk loaders, bootstrappers, system calls, etc.
    ├── compiler            Compiler for K&R C.
    └── executables         Executable file formats and disk formats.
```
