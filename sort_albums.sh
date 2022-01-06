#!/bin/bash

######################################################################
#                              _                               _      
#   ___  _ __ __ _  __ _ _ __ (_)_______   _ __ ___  _   _ ___(_) ___ 
#  / _ \| '__/ _` |/ _` | '_ \| |_  / _ \ | '_ ` _ \| | | / __| |/ __|
# | (_) | | | (_| | (_| | | | | |/ /  __/ | | | | | | |_| \__ \ | (__ 
#  \___/|_|  \__, |\__,_|_| |_|_/___\___| |_| |_| |_|\__,_|___/_|\___|
######################################################################
# Sorts an unsorted directory of album folders alphabetically.
######################################################################

[[ $UID = 0 ]] && 
echo "You probably don't want to run this as root. Exiting..." && exit 1

# set defaults

declare in_path="."
declare out_path="$HOME/Sorted_Music"

# ansi zone

declare grn="\e[0;92m"
declare cyblnk="\e[5m\e[036m"
declare reset="\e[0m"

function usage {
    echo "Usage: $(basename $0) [-hio]" 2>&1
    echo "  -h  help, show usage info"
    printf "  -i  \e[4mpath\e[0m to unorganized files\n"
    printf "  -o  \e[4mpath\e[0m to organized folder\n"
    exit 1
}

function walk_dir {
    declare local path=$1
    for dir in ${path}*/ ;
    do
       cd "${dir}" # TODO get dir name without cd
       declare local folder=${PWD##*/}
       declare local letter=`echo ${folder:0:1} | tr '[a-z]' '[A-Z]'`
       cd ..
       sort_dir "${dir}" "$letter" "$folder"
    done 
}

function sort_dir {
    declare local dir_path=$1
    declare local letter=$2
    declare local folder=$3
    echo "Copying '${dir_path}'..."
    case $letter in
        [A-Z]) declare local type="alpha" &&
            move_dir "$dir_path" "$letter" "$type" "$folder" ;;
        [0-9]) declare local type="num" &&
            move_dir "$dir_path" "$letter" "$type" "$folder" ;;
        ?) declare local type="special" &&
            move_dir "$dir_path" "$letter" "$type" "$folder" ;;
    esac
}

function move_dir {
    declare local dir_path=$1
    declare local letter=$2
    declare local type=$3
    declare local folder=$4
    case $type in
        special) cp -r "$dir_path" "${out_path}_Special Characters/$folder" &&
            printf "${grn}[SUCCESS] $folder copied!${reset}\n"
            printf "${cyblnk}==>${reset} ${out_path}_Special Characters/$folder\n\n" ;;
        num) cp -r "$dir_path" "${out_path}_Numbers/$folder" &&
            printf "${grn}[SUCCESS] $folder copied!${reset}\n"
            printf "${cyblnk}==>${reset} ${out_path}_Numbers/$folder\n\n" ;;        
        alpha) cp -r "$dir_path" "${out_path}$letter/$folder" && 
            printf "${grn}[SUCCESS] $folder copied!${reset}\n"
            printf "${cyblnk}==>${reset} ${out_path}$letter/$folder\n\n" ;;
    esac
}

# parse args

while getopts h:i:o: arg; 
do
    case "${arg}" in
        h) usage ;;
        i) in_path=${OPTARG} ;;
        o) out_path=${OPTARG} ;;
        ?) echo "Invalid option: -${OPTARG}" && usage ;;
    esac
done

# validate in/out dirs

[[ ! -d $in_path ]] && 
echo "No directory '$in_path'. Exiting..." && 
usage

[[ ! -d $out_path ]] && 
echo "Creating output directory..." && 
mkdir -pv $out_path/{A..Z} && 
mkdir -v $out_path/{"_Special Characters","_Numbers"}

# walk dirs and sort

walk_dir $in_path

echo "DONE"
exit 0

