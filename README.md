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

## Using Sinasi

Open up a JavaScript buffer inside a SproutCore project, and type <code>C-h
m</code> to get help for the current mode.  You should see something like:

<pre>
Sinasi minor mode (indicator Sinasi):
Enable Sinasi minor mode providing Emacs support for working
with the SproutCore framework.

key             binding
---             -------

C-c             Prefix Command

C-c ,           Prefix Command

C-c , c         sinasi-clean-tests
C-c , f         Prefix Command

C-c , f a       sinasi-find-core
C-c , f c       sinasi-find-controller
C-c , f f       sinasi-find-fixture
C-c , f i       sinasi-find-main
C-c , f m       sinasi-find-model
C-c , f p       sinasi-find-main-page
C-c , f s       sinasi-find-stylesheet
C-c , f t       sinasi-find-test
C-c , f v       sinasi-find-view
</pre>

For more information on a specific command, you can run <code>C-h f
command-name</code>.  You can use <code>sinasi-clean-tests</code> to work
around stale unit tests in the Test Runner, and you can use
<code>sinasi-bind-finders-with-prefix</code> to map the find commands to
something a bit more convenient.

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
