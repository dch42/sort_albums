# sort_albums
***Script is a work in progress, use with caution***

Shell script to sort unsorted directory of album folders into alphabetically organized subfolders. Assumes album folders begin with artist name, e.g. `%Artist-%Year-%Album`.

## Setup

Clone the repo and add exec permissions to script:

~~~
git clone https://github.com/dch42/sort_albums.git && chmod +x ./sort_albums/sort_albums.sh
~~~

## Usage

### Options

~~~
Usage: sort_albums.sh [-hio]
  -h  help, show usage info
  -i  path to unorganized files
  -o  path to organized folder
~~~

Invoke the script, passing the *input* directory `-i` and *output* directory `-o` as options:
~~~
./sort_albums.sh -i ~/Music/Downloads -o ~/Music/Sorted
~~~

## Directory Structure

Creates a hierarchy in output path like so:

~~~
Sorted/
├── A
│   └── Artist-Album
├── B
│   └── Bartist-Album
├── C
│   └── Cartist-Album
├── D
├── E
...
├── Z
├── _Numbers
└── _Special\ Characters
~~~

The script walks subdirectories of input path, taking note of the name of the folders and copying to output path accordingly. 