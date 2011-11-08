# devcenter
_you might be looking for (The Dev Center)[http://github.com/heroku/dev-center]_

devcenter is a gem that makes it possible to easily edit a Heroku Dev Center
article locally and then push that article to the Dev Center

it also supports importing files into your article

## usage

    $ devcenter compile article.txt

the following will write the article metadata to *article.yml* and use that info for subsequent requests

the article.yml will pick up what you specify on the cmd line using the dotted syntax

    $ devcenter push article.txt --article.title='My Title' --user=user@heroku.com --password=PASSWORD

    $ DEVCENTER_URL=http://localhost:3000 devcenter push article.txt --user=user@heroku.com --password=PASSWORD

    $ devcenter pull article.txt --article.title='My Title' --user=user@heroku.com --password=PASSWORD
