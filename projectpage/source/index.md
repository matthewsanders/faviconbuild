# About
Faviconbuild is a simple set of scripts to automatically generate favicon variants and supporting html markup locally for Mac, Linux, and Windows.

The primary motivation behind Faviconbuild is to create a simple, open source solution for building favicons.

The project is released under the [MIT license](https://github.com/matthewsanders/faviconbuild/blob/master/LICENSE) so feel free to use in both personal or commercial projects.  

If you find an issue, or simply want to extend the scripts, please feel free to [submit a bug](https://github.com/matthewsanders/faviconbuild/issues) or [create a pull request](https://github.com/matthewsanders/faviconbuild/pulls) with your changes.

# Usage
You will first need to [Download ImageMagick](http://www.imagemagick.org/script/binary-releases.php), or if you are on Windows or Mac you can get the binaries packaged with the [latest release](https://github.com/matthewsanders/faviconbuild/releases/latest) of Faviconbuild.

A full listing of commands is given with the `-h` or `--help` parameter.

If you are on Windows and not using a Unix shell environment like Cygwin you can simply use the .bat file provided.  

{% codeblock %}
faviconbuild.bat -h
{% endcodeblock %}

For everyone else there is a shell script of the same name.

{% codeblock %}
./faviconbuild.sh -h
{% endcodeblock %}

This will give you output like this:

{% codeblock %}
usage: build [Options ...]
Options:
	-o  | --outdir          Output Root Directory (where icon and script files are placed)
	-k  | --imagemagick     ImageMagick directory
	-s  | --subdir          Directory where png images are placed
	-ls | --linksubdir      Directory placed in links and content attributes for script
	-i  | --source          Source Image (hint: make this a square image larger then current largest output image)
	-c  | --bgcolor         Background color (used for windows tile)
	-e  | --scriptext       Script Extension (ex: html, ejs, etc.)
	-p  | --parsed          Allows you to override the file to parse for commands
	-h  | --help            This Menu
{% endcodeblock %}

All of the options have fairly sane defaults so if you had an image named `source.png` in the same directory as the script you could simply run the command like:

{% codeblock %}
./faviconbuild.sh
{% endcodeblock %}

The output would be a `build` folder with the following contents:
* a markup file with default name of `favicon.ejs`
* a multi-resolution icon file with default name of `favicon.ico`
* a folder with default name of `favicons` with a list of png images with default name `favicon-{x}x{y}.png`

You can also read [this blog post](https://theknowledgeaccelerator.com/2015/10/10/faviconbuild/) for more information on the development.

# Release with ImageMagick Binaries

The latest release pre-packaged with Windows and Mac [ImageMagick](http://www.imagemagick.org/script/index.php) binaries can be found [here](https://github.com/matthewsanders/faviconbuild/releases/latest).

This may not be up to date with latest master branch, but it does include the same version of ImageMagick used during development.

If you are on Linux or want to get the latest binary check out the [ImageMagick Downloads](http://www.imagemagick.org/script/binary-releases.php).