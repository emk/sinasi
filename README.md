# Sinasi is not a SproutCore IDE

This is hacked-up copy of the excellent [Rinari][rinari] minor mode for
Emacs, modified to work with SproutCore instead of Ruby on Rails.  Sinasi
provides support for quickly switching between models, fixtures, tests, and
other files in a SproutCore project.  (This is especially necessary in
Emacs, since SproutCore uses _lots_ of duplicate filenames.)

For an idea of what Sinasi could become, please see the [Rinari
screencast][rinari].  I eagerly welcome patches to help round-out Sinasi.

## Installing Sinasi

You need three things to use Sinasi:

1. A JavaScript mode of your choice.

2. The Rinari <code>jump</code> module.  I got this by following the
   [Rinari install instructions][rinari].

3. Some configuration in your <code>.emacs</code> file.

        (add-to-list 'load-path "~/.emacs.d/sinasi")
        (require 'sinasi)

With any luck, this _might_ be enough to get you running.  I eagerly
welcome patches that make Sinasi eager to install!

## Generating a TAGS file

I added the following to my <code>.ctags</code> file:

    --exclude=tmp
    --langdef=js
    --langmap=js:.js
    --regex-js=/^([A-Za-z0-9._$]+) = ([A-Za-z0-9._$]+).(create|extend)\(/\1/
    --regex-js=/^[ \t]*([A-Za-z$][A-Za-z0-9_$]+)[ \t]*:[ \t]*function[ \t(]/\1/

...and ran:

    ctags -R -e

Note that this includes the full names of classes, which doesn't always
work gracefully with M-. (for example, you can't look up "Record" directly,
but must edit it to be "SC.Record").  If you have any advice on how to
fine-tune this setup, please let me know.

  [rinari]: http://rinari.rubyforge.org/
