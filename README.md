# irssi-cowsay-fortune


 _________________________________
< I'm the most popular cow in IRC >
 ---------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||


Cowsay and fortune command wrapper for irssi IRC client. Improves the quality of one's life in IRC considerably.

Full disclosure: Personal project merely meant for giggles, serves also as an entry point for the author to PERL scripting. It should be somewhat indicative that the code quality isn't all-time high. 

Feel free to contribute.

## Dependencies

perl + getopt
cowsay and fortune shell commands.

## Installation
The script can be taken into use with the following steps:

1. Clone the repository
2. Run "make install" in the root folder
3. In irssi, load the script. E.g. "/script load ~/.irssi/scripts/cowsay.pl

Optionally you can also autoload the script by creating a symlink from .irss/scripts/autload/ folder to this script.

## To do

1. Preferably this package would be debian-packaged and dependencies to fortune and cowsay would be handled explicitly.

## Contributing

To add or modify a script do the following:

1. Fork this repository on Github.
2. Create a feature branch for your set of patches using git checkout -b foobar.
3. Add or modify your script in the repository.
4. Commit your changes to Git and push them to Github.
5. Submit pull request.

