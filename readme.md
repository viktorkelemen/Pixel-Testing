Pixel testing
=============

for pixel testing websites.

1. Create a list of page URLs you want to test.
2. Run the pixel testign script to create reference screenshots for these pages.
3. Change/tweak/edit these pages and then run pixel testing again, in
   testing mode.
4. It will report you which pages have been changed and which parts
   changed.

This is a great tool to discover not intended changes.
For example, you changed some CSS and you want to make sure that no
other pages are affected.

Dependencies
------------

* [PhantomJS](http://www.phantomjs.org/)

* [Imagemagick](http://www.imagemagick.org/script/index.php) command
  line


Usage
-----

1. Create your onw config file based on *cookpad_live.conf.sample*

2. Create reference screenshots by using the 'r' parameter
    ./pixel_testing.sh -c [your config file] -r

3. Create new screenshots and compare them with the references
    ./pixel_testing.sh -c [your config file]


Config file
-----------

It has the following structure
line #1   project name
line #2   host
line #3   user agent
line #4   page URL
line #5   page URL
...

