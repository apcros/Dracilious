# Dracilious
The Mojo app consumming [DracPerl::Client](https://github.com/apcros/Drac-Perl) to provide a faster and cleaner front-end for Dell server monitoring

## How to use ? 

First install the deps :

        cpanm -l local --installdeps .

Then set your iDRAC configuration in a .cfg in the root folder. (See .cfg.example)

Then run the app !

        perl -Mlocal::lib=local script/dracilious daemon

Dracilious is still very much WIP (As well as Drac-Perl).

## TODO

- Better session caching/ Session lock
- Database
- EVEN M0A4 sensors
- Graph.js
- Password protection
- Better error handling
- Dynamic refresh
- Docker Container

## Screenshots

### v0.2 (Session caching and more sensors)

[![v0.2](http://i.imgur.com/CujrMG2.png)](http://i.imgur.com/CujrMG2.png)

### v0.1 (First release) 

[![v0.1](http://i.imgur.com/0iC58IH.png)](http://imgur.com/0iC58IH)
