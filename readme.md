Pixel testing
=============

Pixel testing websites.

1. Create a list of page URLs you want to test.
2. Run the pixel testign script to create reference screenshots for these pages.
3. Change/tweak/edit these pages and then run pixel testing again, in
   testing mode.
4. It will report you which pages have been changed and which parts
   changed.

This is a great tool to discover not intended changes.

For example, you changed the CSS which caused changes on pages you
don't want to.


Dependencies
------------

* [PhantomJS](http://www.phantomjs.org/)

* [Imagemagick](http://www.imagemagick.org/script/index.php) command
  line

