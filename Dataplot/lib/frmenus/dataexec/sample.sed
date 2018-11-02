#!/bin/csh -f
#
#  SED script to make automatic update to SRM file
#
foreach name (`ls *.DP`)
  sed -e "s/dataloex/dataexec/" $name > junk
  mv junk $name
end
#
