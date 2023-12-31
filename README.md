# YAMB
**Y**et **A**nother **M**icro **B**log.

Static site generator for micro blogs. Heavily inspired by [WorstPress](https://github.com/surprisetalk/worstpress). 

Want a preview? Check out [my blog](http://mirza.town).

## Prerequisites
- Pandoc

## How to use?
 1. Write your first Markdown entry in `entries/recent` directory.
 2. Run `compile.sh` script.
 3. Serve `www` directory.

## Important notes about Markdown files and folder structure
- `About` page will be generated from `templates/about.md` file.
- The name of the Markdown file will be used as the title of the blog entry.
- Category of the blog entry is determinted by the folder name of the Markdown file. 
- If you have an idea for a blog entry place it in the `entries/soon` folder. 
- If you are working on a blog entry place it in the `entries/current` folder. 
- If you are done with it, move it to `entries/recent` folder. 
- For standalone, non-entry pages, place them in `entries/standalone` folder.
- If you any media files, place them in `entries/media` folder.
- First line of the Markdown file will be used as the date of the blog entry and recent entries will be sorted alphabetially according to this date.

## Neat tricks
- You can setup `cron` for running `compile.sh` and `rsync` commands which will generate HTMLs and copy them to a remote server periodically. Voilà! You don't even have to think about the boring stuff. An example cron file is also provided.
- I use `<sub><sup>DATE</sup></sub>` format for the first line of my entries so that the date is small and *neat*. 
- Want to use LaTeX equations in your blog? Check out [this](http://mirza.town/entries/latex_in_markdown_to_html_using_pandoc.html) blog post. YAMB will not automatically add MathJax to your pages so it doesn't load on every page.

---

## TODOs
- [x] The insertion of generated `HTML` files in templates is dependant on the line which we are trying to insert. This can be done without using `sed -i "50r ./tmp/archive.html" ./www/archive.html`. (done in [2241690](https://github.com/doneforaiur/yamb/commit/224169060c72eb4c1dcdc71039bd4424881cc035))
- [x] `Recent` section should include only 10 most recent entries. For now it's handled by checking the line count of the generated HTML, which is not ideal. (done in [7ec715a](https://github.com/doneforaiur/yamb/commit/7ec715a574498a704642172164d6ac3eae226766))
- [x] `Current` section includes entries based on `_` prefix of the Markdown file, also not good. (done in [fce9acc](https://github.com/doneforaiur/yamb/commit/fce9acca2fa2cbdce26c03b269a52d3e1208eec6))
- [x] Generate pages that are not shown as entries, but standalone articles. `books.html`, `podcasts.html`, etc.
- [x] `ls -t` and `stat` commands are not ideal since it sorts by modification time, not creation time. `--time=birth` is not available on *all* filesystems. Sorting the files based on the first line of the file which will include the desired date is a better solution. If date not present, take modification time. (done in [6ee1ec4](https://github.com/doneforaiur/yamb/commit/6ee1ec4f0ce08472acbaa94c506a6e2983ad4204))
- [x] Pages with not enough text to fill the full width of the `body` appear to be more narrow than the rest. (done in [6ee1ec4](https://github.com/doneforaiur/yamb/commit/6ee1ec4f0ce08472acbaa94c506a6e2983ad4204)) 
- [x] `Current` and `Soon` sections be displayed only if there are entries in them. (done in [ccc7b47](https://github.com/doneforaiur/yamb/commit/ccc7b471c65e32c06d78ae14a2a3ffaae09a68c5))
- [ ] Better handling of temporary files for reability.
- [x] RSS. (Wohoo! done in [55d7893](https://github.com/doneforaiur/yamb/commit/55d789326f623f92670920c6fecf60529fe23f5a))