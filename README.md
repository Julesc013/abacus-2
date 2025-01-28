# Project Codename: Abacus 2

**Carbon A1 Minicomputer** and **Carbon Z1 Microcomputer**

[Project Abacus 2 Technical Reference](https://github.com/Julesc013/abacus-2/blob/main/info/manual/Abacus%202%20Technical%20Reference.pdf) (PDF)


## Specifications

- _CPU:_ **Abacus 2** or **Zilog Z80** (16-bit CISC)
- _FPU:_ **AMD Am9511** (Pre-IEEE 754)
- _Clock:_ 1 Hz ~ **16 MHz** (Crystal FM)
- _RAM:_ 48 KB – **1 MB** (SRAM)
- _ROM:_ 8 KB – **128 KB** (PROM)
- _I/O:_ 8 KB – **256 KB** (Memory Mapped)
- _TDD:_ **Compact Cassette** (KCS 240KB/hr)
- _FDD:_ **Floppy Disk** (5.25" DSDD 360KB, 3.5" DSHD 1.44MB)
- _Comms:_ **Serial** (RS-232), **Parallel** (DB-25)
- _Video:_ **Yamaha V9958**, 480p (VESA compatible)
- _Audio:_ **Yamaha OPNB** (SoundBlaster compatible)


## Design Showcase

### System Architecture

16-bit CISC (Von Neumann)

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/z00.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/c04c07.jpg)


### Memory and I/O

4KB–15MB SRAM (8-bit bytes)

4KB–1MB PROM (8-bit bytes)

![Memory map version 5.1](https://github.com/Julesc013/abacus-2/blob/main/hardware/memory/Memory%20Map%205V.png)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/chipset/c01.JPG)


### Instruction Set

Abacus ISA (44 instructions)

Integrated FPU (AMD AM9511)

![Abacus 2 Instruction Set](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/Abacus%202%20Instruction%20Set.jpg)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/Opcode%20Map%20V8C.jpg)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/Addressing%20Modes.jpg)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/instructions/i01i03.jpg)


### Interrupt Handling

16 hardware int's, 110 software int's, 1 non-maskable int, 1 reset int.

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/interrupts/Interrupt%20List.jpg)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/interrupts/v01i04.jpg)


### Video Output

VESA compatible

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/video/video_adapter/CDA%20Technical.png)
![](https://github.com/Julesc013/abacus-2/blob/main/hardware/video/video_adapter/CHAR_SET.PNG)


### System Firmware

Resident monitor, loaders, system routines, etc.

![](https://github.com/Julesc013/abacus-2/blob/main/software/bios/m00.JPG)
![](https://github.com/Julesc013/abacus-2/blob/main/software/executables/Binary%20File%20Format.png)


## Physical Case

![](https://github.com/Julesc013/abacus-2/blob/main/hardware/case/s00s01s02.jpg)


## User Manual

![](https://github.com/Julesc013/abacus-2/blob/main/info/manual/Manual%20Layout.png)

[Abacus 2 Technical Reference](https://github.com/Julesc013/abacus-2/blob/main/info/manual/Abacus%202%20Technical%20Reference.pdf) (PDF)


## Directory Structure
```
├── archive             Archived and old versions of files.
├── hardware            Hardware design and circuitry.
│   ├── case                Physical design of machine.
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

