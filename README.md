Template::Toolkit
=======

Drop-in replacement for Template Toolkit.

I've got a bunch of TT files that I don't want to have to covert by hand to another template scheme, so here's yet another yak that someone else gets to shave for you.

Installation
============

* Using panda (a module management tool bundled with Rakudo Star):

```
    panda update && panda install Template
```

* Is ufo even still a thing?
* Using ufo (a project Makefile creation script bundled with Rakudo Star) and make:

```
    ufo                    
    make
    make test
    make install
```

## Testing

To run tests:

```
    prove -e perl6
```

## Author

Jeffrey Goff, DrForr on #perl6, https://github.com/drforr/

## License

Artistic License 2.0
