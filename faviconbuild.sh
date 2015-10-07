#!/bin/bash

# defaults
outdir=build
subdir=favicons
linksubdir=/$subdir
name=favicon
source=source.png
color=#000000
outext=ejs

if [ "$(uname)" == "Darwin" ]; then
	#echo "Mac"
	imagemagickdir=./mac
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    #echo "Linux"
    imagemagickdir=./linux
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    #echo "Windows"
    imagemagickdir=./windows
fi

# helper functions
usage()
{
	echo "Version: faviconbuild 1.0.0 http://theknowledgeaccelerator.com"
	echo "Copyright: Copyright (C) 2015 Matthew Sanders"
	echo "usage: build [Options ...]"
	echo "Options:"
	echo "	-o  | --outdir          Output Root Directory (where icon and script files are placed)"
	echo "	-k  | --imagemagick     ImageMagick directory"
	echo "	-s  | --subdir          Directory where png images are placed"
	echo "	-ls | --linksubdir      Directory placed in links and content attributes for script"
    echo "	-i  | --source          Source Image (hint: make this a square image larger then current largest output image)"
    echo "	-c  | --bgcolor         Background color (used for windows tile)"
    echo "	-e  | --scriptext       Script Extension (ex: html, ejs, etc.)"
    echo "	-h  | --help            This Menu"
}

convertImage()
{
	source_name=$1
	size_w=$2
	size_h=$3
	bg_color=$4

	if [ "${size_h}" = "" ]; then
		size_h=$size_w
	fi	

	options="-resize ${size_w}x$size_h"

	if [ "${bg_color}" != "" ]; then
		options=${options}" -background "${bg_color}
	fi
	if [ "${size_w}" != "${size_h}" ]; then
		options=${options}" -gravity center -extent ${size_w}x$size_h"
	fi
	${imagemagickdir}convert $source_name $options $outdir$subdir${name}-${size_w}x${size_h}.png
}

createIcon()
{
	files=
	while [ "$1" != "" ]; do
		files="$files$outdir$subdir${name}-${1}x${1}.png "
		shift
	done
	${imagemagickdir}convert $files$outdir${name}.ico
}

createLink()
{
	rel=$1
	size_w=$2
	size_h=$3
	include_sizes=$4
	sizes=
	convert=$5

	if [ "${size_h}" = "" ]; then
		size_h=$size_w
	fi	
	if [ "${include_sizes}" = "true" ]; then
		sizes=' sizes="'${size_w}x${size_h}'"' 
	fi
	echo '<link rel="'${rel}'"'${sizes}' href="'${linksubdir}${name}-${size_w}x${size_h}.png'">' >> $outdir${name}.$outext
	if [ "${convert}" = "true" ]; then
		convertImage $source $size_w $size_h
    fi
}

createMeta()
{
	meta_name=$1
	size_w=$2
	size_h=$3
	convert=$4
	content=$5

	if [ "${content}" = "" ]; then
		content=${linksubdir}${name}-${size_w}x${size_h}.png
	fi
	echo '<meta name="'${meta_name}'" content="'${content}'">' >> $outdir${name}.$outext
	if [ "${convert}" = "true" ]; then
		convertImage $source $size_w $size_h $color
    fi
}

# command line parsing
while [ "$1" != "" ]; do
    case $1 in
        -o | --outdir )         shift
                                outdir=$1
                                ;;
        -k | --imagemagick )    imagemagickdir=$1
                                ;;
        -s | --subdir )    		subdir=$1
                                ;;
        -ls | --linksubdir )   	linksubdir=$1
                                ;;
        -i | --source )   		source=$1
                                ;;                                
        -c | --color )   		color=$1
                                ;;
        -e | --ext )   			outext=$1
                                ;;                                
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# directory fixup
if [ "${outdir}" = "" ]; then
	outdir=.
fi
outdir=${outdir}/
if [ "${subdir}" = "" ]; then
	subdir=.
fi
subdir=${subdir}/
if [ "${imagemagickdir}" = "" ]; then
	imagemagickdir=.
fi
imagemagickdir=${imagemagickdir}/

# main program
mkdir -p $outdir$subdir
rm -f $outdir${name}.$outext

start_token=\$\{
end_token=\}
while IFS='' read -r line || [[ -n "$line" ]]; do
    result_string="${line//,#/$start_token}"
    result_string="${result_string//#,/$end_token}"
    result_string="${result_string//del/rm}"
    result_string="${result_string//:/}"

    eval $result_string
done < "./favinput.txt"
