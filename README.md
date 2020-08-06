[![CI/VSG](https://github.com/Malcolmnixon/FpgaDemo/workflows/CI/VSG/badge.svg)](https://github.com/Malcolmnixon/FpgaDemo/commits/master) [![CI/VUnit](https://github.com/Malcolmnixon/FpgaDemo/workflows/CI/VUnit/badge.svg)](https://github.com/Malcolmnixon/FpgaDemo/commits/master) [![Documented](https://codedocs.xyz/Malcolmnixon/FpgaDemo.svg)](https://codedocs.xyz/Malcolmnixon/FpgaDemo/)

# FPGA Demo Project
This project demonstrates FPGA development including
- Enforcing style (using VHDL Style Guide)
- Test Benches
- Documentation (using Doxygen and CodeDocs)

# Requirements
This project makes use of:
- Python 3.7+
- [VHDL Style Guide](https://github.com/jeremiah-c-leary/vhdl-style-guide)
- [VUnit](https://vunit.github.io/)
- [VHDLTest](https://github.com/Malcolmnixon/VhdlTest)
- [Lattice MachX02-7000HE Breakout Board](https://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/MachXO2BreakoutBoard)
- [Lattice Diamond 3.11](http://www.latticesemi.com/latticediamond)
- [Doxygen 1.8.18](https://www.doxygen.nl/index.html)

# Test Benches
This project demonstrates four different styles of writing test benches:
- 'Long Code' style:
  - Pro: Easy to review for SQA engineers
  - Con: Ludicrously long
- 'Stimulus Array' style:
  - Pro: Highly portable and reliable
  - Con: Adding tests requires modifying code
- 'Stimulus File' style:
  - Pro: Can add additional tests without recompiling
  - Con: Easy to break file, and file-path in code can cause issues with different working directories
- 'VUnit' style:
  - Pro: Extended set of capabilities (watchdog, complex testing, etc.)
  - Con: Adds dependency on VUnit library which may break in-IDE test-bench runners
  
At this point the 'Stimulus Array' seems the best.
