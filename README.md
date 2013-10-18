# WebDiff

Semi-automatic tool for creating difference images between two websites.

## requirements

You need to have a selenium hub server running somewhere, with a phantomjs
browser connected, and you need ImageMagick. You also need
`Selenium::Remote::Driver` and `p5-mop-redux` for the perl-part.

for mac I did this

```
brew install selenium-standalone-server
brew install imagemagick
java -jar /usr/local/opt/selenium-server-standalone/selenium-server-standalone-2.35.0.jar -p 4444 -role hub &
phantomjs --webdriver=8080 --webdriver-selenium-grid-hub=http://127.0.0.1:4444/ &
```

## running wdiff

```
./wdiff url-a url-b selector-to-remove
```

For instance

```
./wdiff http://www.google.com/ http://www.yahoo.com/ #header_ad
```

would fetch google.com, remove `#header_ad` element from markup, and save
a screenshot, then fetch yahoo.com, remove `#header_ad` element from markup and
save another screenshot. Then it uses imagemagick to compose a difference image
for the two screenshots.
