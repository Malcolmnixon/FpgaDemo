from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
lib = VU.add_library("common")
lib.add_source_files("common/source/*.vhd")
lib.add_source_files("common/sim_vunit/*.vhd")
VU.main()
