#!/bin/env bash

# This program looks through $1 Location for the Keyword $2, and if the file contains $2, Filters and places it in path: $3/$1
# USAGE HELP ./net.sh where_search search_for where_put
# USAGE EXAMPLE ./filterPush.sh .(here) Lavender ../extractedBags
#============================================================================

# This Takes in the input variables, It assumes variable paths are given in relative terms, and converts to absolute,
# This way, if user inputs an absolute path, it will still work.
r_WHERE_SEARCH=$1 # Check Through Which Directory
KEYWORD=$2 # Target Keyword, Group all Items with this Keyword and Put them In Folder Labelled KEYWORD
r_WHERE_PUT=$3 # Intended File Location's Destination Directory # IT ACTUALLY PUTS FILES IN A_WHERE_PUT/KEYWORD

# Convert and Print Relative Path to Absolute Path to allow user to use the program both relatively and absolutely
cd $r_WHERE_SEARCH
A_WHERE_SEARCH=`pwd`
cd ~-
# Convert and Print Relative Path to Absolute Path to allow user to use the program both relatively and absolutely
cd $r_WHERE_PUT
A_WHERE_PUT=`pwd`
cd ~-


directoryCheck(){
cd $A_WHERE_PUT
if [ -d ${KEYWORD^} ]; then # Is there already a directory with target name there? # If Yes
    echo "Successfully Located Existing Directory:" ${KEYWORD^} # Inform The User
else # No  
    echo "Cannot Locate Existing Directory" ${KEYWORD^} # Inform The User
    cd $A_WHERE_PUT
    mkdir ${KEYWORD^} # Make New Directory
    echo ${KEYWORD^} "Directory Created in: " $A_WHERE_PUT
    
fi
}
directoryCheck

find $A_WHERE_SEARCH -type f -iname "*$KEYWORD*" -exec mv {} $A_WHERE_PUT/$KEYWORD \;
echo "${KEYWORD^} has been sorted into $A_WHERE_PUT/${KEYWORD^}"
echo ""
