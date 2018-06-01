# Dotfiler

Dotfiler is a CLI gem for managing dotfiles.

## Contents

* [**Installation**](#installation)
* [**Usage**](#usage)
    * [Initial setup](#initial-setup)
    * [Creating new dotfile](#creating-new-dotfile)
    * [Listing managed dotfiles](#listing-managed-dotfiles)
    * [Removing existing dotfile](#removing-existing-dotfile)
    * [Editing dotfiles](#editing-dotfiles)
    * [Installing dotfiles](#installing-dotfiles)
    * [Backing up existing dotfiles](#backing-up-existing-dotfiles)
    * [Checking the version](#checking-the-version)
* [**Code of Conduct**](#code-of-conduct)
* [**License**](#license)

## Installation

Make sure you have Ruby >= 2.3 installed.

To install Dotfiler, run:

    $ gem install dotfiler

## Usage

### Initial setup

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
      --[no-]git            # Initialize git repo for dotfiles directory, default: true
      --help, -h            # Print this help

Example:

    $ dotfiler init ~/code/my_dotfiles
    #  Creating config file (/Users/aleksandar/.dotfiler)...
    #  Creating dotfiles directory (/Users/aleksandar/code/my_dotfiles)...
    #  Creating dotfiles file (/Users/aleksandar/code/my_dotfiles/.dotfiles)...
    #  Initialized empty Git repository in /Users/aleksandar/code/my_dotfiles/.git/

As you can see, `init` command does 4 things:

1. Creates Dotfiler configuration (YAML) file (`.dotfiler`) in your home directory.
2. Creates a directory where dotfiles will be kept, at specified location.
3. Creates a file (`.dotfiles`) which holds necessary info about each dotfile
you add. The file is created in dotfiles directory.
4. Initializes Git repo in dotfiles directory. You can skip this by passing
`--no-git` option.

**NOTE:** If any of the files/dirs already exist, you will be prompted to either overwrite or
keep them.

### Adding new dotfile

To add a file/directory to your dotfiles, use `add` command.

    $ dotfiler add --help
    Command:
      dotfiler add

    Usage:
      dotfiler add PATH

    Description:
      Add specified file/directory to dotfiles

    Arguments:
      PATH                        # REQUIRED File/directory path

    Options:
      --name=VALUE, -n VALUE      # Name which will be assigned to dotfile
      --target=VALUE, -t VALUE    # Path to where the symlink will be created
      --help, -h                  # Print this help

Example:

    $ dotfiler add ~/.zshrc
    #  Moving /Users/aleksandar/.zshrc to dotfiles directory (/Users/aleksandar/code/my_dotfiles)...
    #  Symlinking dotfile (/Users/aleksandar/code/my_dotfiles/.zshrc) to /Users/aleksandar/.zshrc...
    #  Adding zshrc to dotfiles...

`add` command does 3 things:

1. Moves specified file/directory to dotfiles directory.
2. Creates a symbolic link in file's/dir's original location which points to
it's new location in dotfiles directory. If you want to change the symlink's
location, use `--target` option.
3. Updates `.dotfiles` file.

Dotfile consists of **name**, **path** and **link**:

- **Name** serves as a unique identifier for a dotfile. By default, name of the
file will be used as a dotfile name (without starting dots/underscores). You can
set a custom name for a dotfile with `--name` option.
Name is used for specifying which dotfile to remove or edit.
- **Path** is an actual dotfile path (in dotfiles directory).
- **Link** is a symbolic link path

Aliases: `a`

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


Aliases: `ls`

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
      NAME                  # REQUIRED Name of the dotfile that should be removed

    Options:
      --help, -h                            # Print this help

Example:

    $ dotfiler remove zshrc
    #  Removing symlink (/Users/aleksandar/.zshrc)...
    #  Restoring dotfile (/Users/aleksandar/code/my_dotfiles/.zshrc) to its original location (/Users/aleksandar/.zshrc)...
    #  Removing 'zsh' from dotfiles...

`remove` command does 3 things:

1. Removes dotfile symbolic link.
2. Moves the file/dir from dotfiles directory to a location of previously removed symlink.
3. Updates `.dotfiles` file.

Aliases: `rm`

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
      NAME                     # REQUIRED Name of the dotfile you want to edit

    Options:
      --with=VALUE, w VALUE    # Editor in which to open the specified dotfile
      --help, -h               # Print this help

    $ dotfiler edit zshrc
    #### This will open ~/code/my_dotfiles/.zshrc file in $EDITOR ####

You can specify a different editor by using `--with` option:

    $ dotfiler edit zshrc --with=vim

Aliases: `e`

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
      --help, -h            # Print this help

Example:

    $ dotfiler install ~/code/my_dotfiles

`install` command will create symlinks of files located in specified dotfiles directory,
by looking at `.dotfiles` file. If symlink's location is already taken, it will:

- Overwrite the file if it is **a symbolic link**
- Backup file/dir if it is **not a symbolic link**

Backed up files will be placed in `dotfiler_installation_backup_{{CURRENT_TIMESTAMP}}`
directory, located in your home directory,

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

### Checking the version

To check Dotfiler version, run:

    $ dotfiler version

Aliases: `v, -v, --version`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aradunovic/dotfiler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Dotfiler project’s codebases and issue trackers is expected to follow the [code of conduct](https://github.com/aradunovic/dotfiler/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

