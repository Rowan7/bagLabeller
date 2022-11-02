#!/bin/env bash
# USAGE // Just pass the ./net.sh parameters minus the keyword (as it looks different keywords through an array)
# USAGE HELP ./fileSort where_search where_put
# USAGE EXAMPLE ./fileSort .(here) ../extractedBags
#============================================================================

cropArray=("Celery" "Springwheat") #"Wheat" "Barley" "Springbean" "Sugarbeet" "Lettuce" "OilseedRape" "Rape" "Onion" "Brocolli" "Carrot" "Choy" "Fennel" "Lavender" "Leek" "Spinach" "Cabbage")
locationArray=("Pearce" "Lincoln")
formatArray=("_RGB_" "_RGBD_" "_IRD_" "_RGBIRD_")

A_PROGRAM_HOME=`pwd` # A path to get the location of where the all the program files are, when running .net or addKeyValue, this must be used
r_WHERE_SEARCH=$1 # Check Through Which Directory
r_WHERE_PUT=$2 # Intended File Location's Destination Directory # IT ACTUALLY PUTS FILES IN A_WHERE_PUT/KEYWORD
#crop_
# Convert and Print Relative Path to Absolute Path to allow user to use the program both relatively and absolutely
cd $r_WHERE_SEARCH
A_WHERE_SEARCH=`pwd`
cd ~-
# Convert and Print Relative Path to Absolute Path to allow user to use the program both relatively and absolutely
cd $r_WHERE_PUT
A_WHERE_PUT=`pwd`
cd ~-




cropSort() {
echo "=================================#      CROP SORT      #================================="
for crop in ${cropArray[@]}; do 
    echo "Sorting: $crop"
  ./net.sh $r_WHERE_SEARCH $crop $r_WHERE_PUT # Organises all files into Crop Directories Directory
done
echo "================================#  CROP SORT COMPLETE  #================================="
cd $A_WHERE_PUT
}

locationSort() {
echo ""
echo "===============================#      LOCATION SORT     #================================"

for d in */ ; do # List all Directories in the Crop Directory Directory
    cd $d # Go to each directory
    echo "Directory $d" #print directory
    A_WHERE_SEARCH_NEW=$A_WHERE_PUT/$d # Update these new locations to be a directory deeper #HAVE TO CALL IT NEW VARIABLE BECAUSE EACH TIME IT RUNS
    A_WHERE_PUT_NEW=$A_WHERE_PUT/$d # Update these new locations to be a directory deeper                 #THROUGH THE LOOPS ID JUST ADDS /$d ONTO THE END OF ITSELF

    for location in ${locationArray[@]}; do
      echo "Directory $location"

      $A_PROGRAM_HOME/net.sh $A_WHERE_SEARCH_NEW $location $A_WHERE_PUT_NEW # Organises all files into Location Directories within Crop Directories
    done
    echo ""
    cd ~-
done
echo "===========================#      LOCATION SORT COMPLETE     #==========================="
}

#PLEASE DON'T HAVE SPACES IN THE FILE NAMES THANKS
#Currently Adds, CROP, LOCATION, 
appendToJSON() {
echo ""
echo "============================#      POPULATE KEY VALUES     #============================="
for d in */ ; do
  echo ""
  echo "Crop Directory: $d" # Go through each Crop
  cropValue=${d%/}
  cd $d
  for d in */ ; do
    echo ""
    echo "Location Directory: $d" # Go through each Location
    locationValue=${d%/}
    cd $d
    for f in ./*.bag; do  # Go through each File 

      epochTime=` date -r $f "+%s"`
      epochToUTC=` date --utc --date "1970-01-01 $epochTime seconds" +"%Y-%m-%d-%H-%M-%S"`

      python3 $A_PROGRAM_HOME/addKeyValue.py $A_WHERE_PUT/$cropValue/$locationValue/$f "crop" $cropValue # Add Crop KeyValue to .json
      python3 $A_PROGRAM_HOME/addKeyValue.py $A_WHERE_PUT/$cropValue/$locationValue/$f "location" $locationValue # Add Location KeyValue to .json
      python3 $A_PROGRAM_HOME/addKeyValue.py $A_WHERE_PUT/$cropValue/$locationValue/$f "dateCreated" $epochToUTC # Add dateCreated KeyValue to .json

      for i in ${formatArray[@]}; do
      find . -type f \( -iname "*$i*" -a -name "*.json" \) -exec python3 $A_PROGRAM_HOME/addKeyValue.py $A_WHERE_PUT/$cropValue/$locationValue/{} "format" "${i//_/}" \; # Add format KeyValue 
      done                                                                                                                                                                # to .json

    done
    cd ~-
  done
  cd ../
done
echo "========================#      POPULATE KEY VALUES COMPLETE    #========================="
}


cropSort
locationSort
appendToJSON


