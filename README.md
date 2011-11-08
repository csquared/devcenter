# devcenter
_you might be looking for [The Dev Center](http://github.com/heroku/dev-center)_

devcenter is a command line tool that makes it possible to easily pull and edit a 
Heroku Dev Center article locally and then push that article to the Dev Center

once the article has been downloaded (or written from scratch) you can import subfiles
via the following synatx:

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

## usage

### compile
compile an article from a top file and imported subfiles

    $ devcenter compile article.txt

### push
send an article to the devcenter

    $ devcenter push article.txt --article.title='My Title' --user=user@heroku.com --password=PASSWORD

    $ DEVCENTER_URL=http://localhost:3000 devcenter push article.txt --user=user@heroku.com --password=PASSWORD

### pull
get an article from the devcenter

    $ devcenter pull article.txt --article.title='My Title' --user=user@heroku.com --password=PASSWORD

push and pull will write the article metadata to *article.yml* and use that info for subsequent requests

command line arguments --article.attribute will override and replace what is in article.yml
