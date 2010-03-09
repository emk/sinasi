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

[rinari]: http://rinari.rubyforge.org/
