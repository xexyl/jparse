#!/usr/bin/env bash

# we have to clone certain repos for the build to succeed as we require their
# header files and their libraries.

# first we need the dbg api from the dbg repo at https://github.com/lcn2/dbg.
git clone https://github.com/lcn2/dbg
cd dbg && make clobber all
sudo make install

# next we need the dyn_array api from the dyn_array repo at
# https://github.com/lcn2/dyn_array.
git clone https://github.com/lcn2/dyn_array
cd dyn_array && make clobber all
sudo make install

# and then we need the pr api from the pr repo at
# https://github.com/lcn2/pr.
git clone https://github.com/lcn2/pr
cd pr && make clobber all
sudo make install

