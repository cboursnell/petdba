# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# Give it a name
extension_name = 'assembler/assembler'

$CFLAGS = '-Wall -O3' # O for optimise

# The destination
dir_config(extension_name)

# Do the work
create_makefile(extension_name)