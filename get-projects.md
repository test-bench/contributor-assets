<img src="https://test-bench.software/test-bench-icon-130x115.png" />

# Downloading the TestBench Project Code

The `get-projects.sh` script will clone or pull all project repositories to your device.

## Clone or Pull

If the working copy directory is not in the project directory, the repository will be downloaded via `git clone`. If there is a corresponding working copy, the working copy will be updated via `git pull`.

## Test Bench Directory

Create a directory that will be the parent directory for all of the TestBench libraries and tools. All repositories will be cloned into this directory.

It's common to use the directory name, "test-bench", but it can be any name you like.

The rest of this document assumes that the directory is named "test-bench".

Create the directory:

`mkdir test-bench`

And then change directory into this new directory.

`cd test-bench`

## PROJECTS_HOME Environment Variable

In order for the `get-projects.sh` script to work, you must set am environment variable.

The `PROJECTS_HOME` environment variable must contain the path to the "test-bench" directory that you created (above).

For example, for a project directory in your home folder:

`PROJECTS_HOME=~/test-bench`

You can set the variable in your current shell, on the command line when you execute the script, or in your shell profile scripts using `export`:

`export PROJECTS_HOME=~/test-bench`

## Clone the "contributor-assets" Repository

From the "test-bench" directory

`git clone git@github.com:test-bench/contributor-assets.git`

## Change Directory to the contributor-assets Directory

`cd contributor-assets`

## Run the Script

From the command line, within the "eventide" directory:

`./get-projects.sh`
