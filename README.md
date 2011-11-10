# devcenter
_you might be looking for [The Dev Center](http://github.com/heroku/dev-center)_

devcenter is a command line tool that makes it possible to easily pull and edit a 
Heroku Dev Center article locally and then push that article to the Dev Center

once the article has been downloaded (or written from scratch) you can import subfiles

## install

until we have a better way

    $ gem source -a http://anything:samurai14@herokugems.herokuapp.com
    $ gem install devcenter

## usage

### compile
compile an article to STDOUT from a top file and imported subfiles

    $ devcenter compile article.txt

### push
compile an article and send and it to the devcenter

    $ devcenter push article.txt --article.title='My Title' 

    $ DEVCENTER_URL=http://localhost:3000 devcenter push article.txt 

use the open flag to open the article in your browser

    $ devcenter push article.txt --open 

### pull
write an article to STDOUT from the devcenter

    $ devcenter pull article.txt --article.title='My Title'

push and pull will prompt for your devcenter login
* google apps auth not supported yet

### article.yml
push and pull will also write the article metadata to *article.yml* and use that info for subsequent requests

command line arguments --article.attribute will override and replace what is in article.yml

## import

compile uses the <code>!import</code> call to import other files

push compiles the article on the fly


Given 'filename' is a file that contains "hello, world"

a file with

    !import(filename)

becomes

    hello, world

a file with

    !import(filename.rb)

becomes

    :::ruby
    hello, world

and a file with 

    !import(filename, syntax)

becomes

    :::syntax
    hello, world


- file locations are relative
- indentation is preserved
- syntax highlighting is detected by filename

## Todo

- better authentication
- have devcenter be a real API
