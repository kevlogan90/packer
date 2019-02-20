# Packer Templates

A small collection of templates to build packer images.

# How to use

Build a base OS image (i.e. Ubuntu):  
`./build.sh ubuntu-base bionic`

Build a provisioner, using the latest stable version of a certain base OS:  
`./build.sh salt-provisioner master ubuntu-base bionic latest stable`

Build an image based off of a provisioner for a certain base OS:  
`./build.sh superimportant test_image ubuntu-base bionic latest stable salt-provisioner`

# Folder/File structure

## Important files

Each folder for the OS, Provisioners, and Apps should have a `main.json`, which is the core piece
on what packer will use to build that piece of the image.

They should also have some sort of `variables.json` for the specific build type.

For example:

If we want to build an ubuntu bionic image, then we should have a folder

```
base/ubuntu
  |_ main.json (contains the 'builders' section of the packer template)
  |_ bionic.json (contains variables unique to this releaes/image)
``` 

## Common

These are files that will be common to all packer builds (based on the way `build.sh` currently works).
Right now, the running of a small amount of tests and exporting/naming of the resulting image live here.

## Base

These are base operating systems that will be build upon (i.e. Ubuntu). Under the base OS folder, if there
are things that can be shared amongst multiple versions of that OS, then they should exist in another `common`
directory (to be shared for that OS only).

## Provisioner

These are templates to provision the VMs using whatever types desired. (i.e. salt-masterless)

### Salt

For the salt provisioner, the salt `states` and `pillar` files should be added under the `salt-provisioner/saltstack/`
directory. This will get pulled up into the image to actually provisioner the build image.

## Apps

This folder would be for specific applications (i.e. final product builds). This is where the templates that
will be used to build the image that is to be deployed would go.

## Images

This is the final output directory that all build artifacts go. The folder structure naming convention is:

`./images/<OS>/<RELEASE>/<APP>/<BUILD>/<BUILDTYPE>/<VERSION>/<OS>-<RELEASE>-<APP>-<BUILD>-<VERSION>.<ext>`

or more visually:

```
./images
  |_ rancheros
     |_  ...
  |_ ubuntu (os)
     |_ xenial
        |_  ...
     |_ bionic (release)
       |_ base (app)
         |_ stable (build)
           |_ virtualbox (build-type)
             |   manifest.json
             |
             |_ latest -> 1549506815 (version)
             |    ubuntu-bionic-base-stable-1549506815.ova
             |    base.ova -> ./ubuntu-bionic-base-stable-1549506815.ova
             |    sha256.checksum
             |    ...
             |
             |_ 1549506815
                |  ...
```
