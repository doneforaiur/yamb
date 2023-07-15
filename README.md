# YAMB
**Y**et **A**nother **M**icro **B**log.

Heavily inspired by [WorstPress](https://github.com/surprisetalk/worstpress) by Taylor Troesh. 

## Prerequisites
- Pandoc

## How to use?
 1. Write your Markdown blog entries in `entries` directory.
 2. Run `compile.sh` script.
 3. Serve `www` directory.

## Neat tricks

You can setup `cron` for running `compile.sh` and `rsync` commands which will generate HTMLs and copy them to a remote server periodically. Voilà! You don't even have to think about the boring stuff. An example cron file is also provided.

## TODOs
- [ ] The insertion of generated `HTML` files in templates is dependant on the line which we are trying to insert. This can be done without using `sed -i "50r ./tmp/archive.html" ./www/archive.html`.
- [ ] `Recent` section should include only 10 most recent entries. For now it's handled by checking the line count of the generated HTML, which is no ideal.
- [ ] `Current` section includes entries based on `_` prefix of the Markdown file, also not good.
- [ ] RSS.
