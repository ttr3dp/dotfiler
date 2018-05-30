# Dotfiler

Dotfiler is a CLI gem for managing dotfiles.

## Contents

* [**Installation**](#installation)
* [**Usage**](#usage)
    * [Initial setup](#initial-setup)
    * [Creating new dotfile](#creating-new-dotfile)
    * [Removing existing dotfile](#removing-existing-dotfile)
    * [Listing managed dotfiles](#listing-managed-dotfiles)
    * [Editing dotfiles](#editing-dotfiles)
    * [Installing dotfiles](#installing-dotfiles)
    * [Backing up existing dotfiles](#backing-up-existing-dotfiles)
* [**Code of Conduct**](#code-of-conduct)
* [**License**](#license)

## Installation

Make sure you have Ruby >= 2.1 installed.

To install Dotfiler, run:

    $ gem install dotfiler

## Usage

### Initial setup

Initial setup assumes that you are starting from scratch and there is no existing dotfiles management system.

    $ dotfiler init --help
    Command:
      dotfiler init

    Usage:
      dotfiler init PATH

    Description:
      Create config file. Create dotfiles directory at specified path. Initialize git repo.

    Arguments:
      PATH                  # REQUIRED Path where the Dotfiles directory will be created

    Options:
      --[no-]git                            # Initialize git repo for dotfiles directory, default: true
      --help, -h                            # Print this help

Example:

    $ dotfiler init ~/code/my_dotfiles
    #  Creating config file (/Users/aleksandar/.dotfiler)...
    #  Creating dotfiles directory (/Users/aleksandar/code/my_dotfiles)...
    #  Creating dotfiles file (/Users/aleksandar/code/my_dotfiles/.dotfiles)...
    #  Initialized empty Git repository in /Users/aleksandar/code/my_dotfiles/.git/

### Creating new dotfile

To add a file/directory to your dotfiles, use `add` command.

    $ dotfiler add --help
    Command:
      dotfiler add

    Usage:
      dotfiler add NAME PATH

    Description:
      Add specified file/directory to dotfiles

    Arguments:
      NAME                  # REQUIRED Name under which the dotfile will be created
      PATH                  # REQUIRED File/directory path

    Options:
      --target=VALUE, -t VALUE              # Path to where the symlink will be created
      --help, -h                            # Print this help

Example:

    $ dotfiler add zsh ~/.zshrc
    #  Moving /Users/aleksandar/.zshrc to dotfiles directory (/Users/aleksandar/code/my_dotfiles)...
    #  Symlinking dotfile (/Users/aleksandar/code/my_dotfiles/.zshrc) to /Users/aleksandar/.zshrc...
    #  Adding zsh to dotfiles...

### Removing existing dotfile

To remove a dotfile, use `remove` command.

    $ dotfiler remove --help
    Command:
      dotfiler remove

    Usage:
      dotfiler remove NAME

    Description:
      Remove specified dotfile from dotfiles and restore it to it's original location

    Arguments:
      NAME                  # REQUIRED Name of the dotfile that should be unlinked

    Options:
      --help, -h                            # Print this help

Example:

    $ dotfiler remove zsh
    #  Removing symlink (/Users/aleksandar/.zshrc)...
    #  Restoring dotfile (/Users/aleksandar/code/my_dotfiles/.zshrc) to its original location (/Users/aleksandar/.zshrc)...
    #  Removing 'zsh' from dotfiles...

### Listing managed dotfiles

To get a list of all currently managed dotfiles, use `list` command.

    $ dotfiler list --help
    Command:
      dotfiler list

    Usage:
      dotfiler list [NAMES]

    Description:
      List all managed dotfiles

    Arguments:
      NAMES                 # List only names of managed dotfiles

    Options:
      --help, -h                            # Print this help

Example:

    $ dotfiler list
    zsh
      - LINK: /Users/aleksandar/.zshrc
      - PATH: /Users/aleksandar/code/my_dotfiles/.zshrc

### Editing dotfiles

To edit a dotfile, use `edit` command.

    $ dotfiler edit --help
    Command:
      dotfiler edit

    Usage:
      dotfiler edit NAME

    Description:
      Edit specified dotfile. By default, dotfile will be opened in $EDITOR

    Arguments:
      NAME                  # REQUIRED Name of the dotfile you want to edit

    Options:
      --with=VALUE, w VALUE                 # Editor in which to open the specified dotfile
      --help, -h                            # Print this help

    $ dotfiler edit zsh
    #### This will open ~/.zshrc file in $EDITOR ####

### Installing dotfiles

To install all dotfiles, use `install` command.

    $ dotfiler install --help
    Command:
      dotfiler install

    Usage:
      dotfiler install PATH

    Description:
      Install dotfiles from existing dotfiles directory

    Arguments:
      PATH                  # REQUIRED Path to existing dotfiles directory

    Options:
      --help, -h                            # Print this help

Example:

    $ dotfiler install ~/code/my_dotfiles

### Backing up existing dotfiles

To back up existing dotfiles, use `backup` command.

    $ dotfiler backup --help
    Command:
      dotfiler backup

    Usage:
      dotfiler backup

    Description:
      Backup existing dotfiles directory

    Options:
      --help, -h                            # Print this help

Example:

    $ dotfiler backup
    #  Backing up dotfiles directory (/Users/aleksandar/code/my_dotfiles) to Users/aleksandar/.dotfiler_backup_2018-29-05-10-00-00

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aradunovic/dotfiler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Dotfiler project’s codebases and issue trackers is expected to follow the [code of conduct](https://github.com/[USERNAME]/dotfiler/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

