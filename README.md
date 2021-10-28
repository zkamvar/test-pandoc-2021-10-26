# Testing Pandoc Issue

**update**: I opened an issue here that may have triggered the fix: https://github.com/jgm/pandoc/issues/7639

I've noticed some errors pop up with the latest pandoc in combination with one
of my lua filters that modifies links to flatten them and replace source 
extensions with output extensions.

It appears that the nightly version of pandoc decides to turn everything into
an embedded or image and it's really confusing. The weird thing is: this does
not happen with the docker version:

```bash
docker run --rm -it --volume $(pwd):/data/ \
  pandoc/core:latest ex.md \
  --to html4 --from markdown --lua-filter filter.lua > expected-filter.html
```

## The Source

```markdown
This [link should be transformed](../learners/Setup.md)

This [rmd link also](../episodes/01-Introduction.Rmd)

This [rmd is safe](https://example.com/01-Introduction.Rmd)

This [too](../learners/Setup.md#windows-setup 'windows setup')

![link should be transformed](../episodes/fig/Setup.png){alt='alt text'}
```

## What I expect

This is what I expect from the filter:

```html
<p>This <a href="Setup.html">link should be transformed</a></p>
<p>This <a href="01-Introduction.html">rmd link also</a></p>
<p>This <a href="https://example.com/01-Introduction.Rmd">rmd is safe</a></p>
<p>This <a href="Setup.html#windows-setup" title="windows setup">too</a></p>
<div class="figure">
<img src="fig/Setup.png" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
```

## What I get

Instead, I get a weird mishmash of embeds and images

```html
<p>This <embed src="Setup.html" /></p>
<p>This <embed src="01-Introduction.html" /></p>
<p>This <img src="https://example.com/01-Introduction.Rmd" alt="rmd is safe" /></p>
<p>This <embed src="Setup.html#windows-setup" title="windows setup" /></p>
<div class="figure">
<img src="fig/Setup.png" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
<p>This <embed src="Setup.html" /></p>
<p>This <embed src="01-Introduction.html" /></p>
<p>This <img src="https://example.com/01-Introduction.Rmd" alt="rmd is safe" /></p>
<p>This <embed src="Setup.html#windows-setup" title="windows setup" /></p>
<div class="figure">
<img src="fig/Setup.png" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
```

## Make it simple

I've also attempted to simplify the filter to just replace the URI with a link
to one of [my favorite meat purveyors in Oregon](https://oregonpeppertree.com/) 
(no grep or anything), but the pattern still persists.

```bash
docker run --rm -it --volume $(pwd):/data/ \
  pandoc/core:latest ex.md \
  --to html4 --from markdown --lua-filter falter.lua > expected-sausage.html
```

## What I expect

This is what I expect from the filter:

```html
<p>This <a href="https://oregonpeppertree.com/">link should be transformed</a></p>
<p>This <a href="https://oregonpeppertree.com/">rmd link also</a></p>
<p>This <a href="https://oregonpeppertree.com/">rmd is safe</a></p>
<p>This <a href="https://oregonpeppertree.com/" title="windows setup">too</a></p>
<div class="figure">
<img src="https://oregonpeppertree.com/" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
```

## What I get

Instead, I get a weird mishmash of embeds and images

```html
<p>This <img src="https://oregonpeppertree.com/" alt="link should be transformed" /></p>
<p>This <img src="https://oregonpeppertree.com/" alt="rmd link also" /></p>
<p>This <img src="https://oregonpeppertree.com/" alt="rmd is safe" /></p>
<p>This <img src="https://oregonpeppertree.com/" title="windows setup" alt="too" /></p>
<div class="figure">
<img src="../episodes/fig/Setup.png" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
<p>This <img src="https://oregonpeppertree.com/" alt="link should be transformed" /></p>
<p>This <img src="https://oregonpeppertree.com/" alt="rmd link also" /></p>
<p>This <img src="https://oregonpeppertree.com/" alt="rmd is safe" /></p>
<p>This <img src="https://oregonpeppertree.com/" title="windows setup" alt="too" /></p>
<div class="figure">
<img src="https://oregonpeppertree.com/" alt="alt text" />
<p class="caption">link should be transformed</p>
</div>
```
