---
title: Building a digital archive for the preservation of local memories (with Omeka S), at the intersection of public history and digital history
author: Giorgio Comai
date: '2020-12-31'
slug: []
categories: ["Blog"]
tags: ["omeka"]
subtitle: ''
summary: ''
authors: []
lastmod: '2020-12-30T23:26:17+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: ["digital-archives-and-local-history"]
---


This post outlines some of the practicalities and the many choices involved in setting up a digital archive for the preservation of the memories and lived experiences of residents of a community in the Alps (Valle dei Laghi, Trentino, Italy).

## Some context about the initiative

The *Archivio della Memoria* is an endevaour characterised by its distinct geographic delimitation as well as by the extensive understanding of what kind of contents should be included in the archive, ranging from old pictures to physical objects, and including recent audio and video materials describing or illustrating local traditions and anecdotes from daily life.

Similarly to what happened to rural and mountain communities across Europe, life in our community has changed completely for the large majority of residents in the lapse of a few decades.  Even if there is a chance that old pictures may be preserved for many years to come in personal collections, with time it would become increasingly impossible to talk to people able to locate them or make sense of what they represent. A significant part of the work is therefore not only to collect and digitise pictures, documents, or other artifacts, but to give context and detail to these very materials in a way that would otherwise soon become impossible. 

In the early stage of the initiative, archivists, historians and others working in museums or adjacent sectors have been consulted, yet no professional historian has been directly involved in producing the actual contents now available online ([https://archiviomemoria.ecomuseovalledeilaghi.it/](https://archiviomemoria.ecomuseovalledeilaghi.it/)). Professional historians may smirk at some of the descriptions and phrasing, yet, they will hopefully recognise that this as a source of interesting details and evidence that would otherwise have been lost. 

The *Archivio della Memoria* is an initiative by the local [ecomuseum](https://en.wikipedia.org/wiki/Ecomuseum), the [Ecomuseo della Valle dei Laghi](ecomuseovalledeilaghi.it), and it received some initial funding that made it possible to acquire a good scanner, set up the website, and have at least some materials ready to be included in the archive. After that, it remains largely a volunteer-based initiative. 

The working group of contributors has been coordinated by Rosetta Margoni, a retired school-teacher, the website has been originally set up by [Roxana Todea](https://roxanatodea.com), and I, a researcher and data analyst with no previous experience of public history, have contributed to the conversation on metadata and to the tiny details related to bending the platform we chose for the archive to our needs. All of us involved in this initiative live in Valle dei Laghi.

## Choosing the platform, Omeka S

The reasons for choosing *[Omeka S](https://omeka.org/)* over available alternatives are many. They are detailed extensively, in Italian, [in this document](https://istruzioniarchiviomemoria.ecomuseovalledeilaghi.it/principi-e-riflessioni-preliminari.html). 

In brief, Omeka S seemed to be the more mature and accessible among open source options. We have seen similar initiatives and other digital archives opting for customised versions of other open source solutions (e.g. adapting Drupal to this purpose), but we felt that using a CMS specifically developed for archives would have constantly nudged us towards better archiving practices and facilitated long-term availability of the data at multiple levels. I feel non-open source solutions without a clear path for transfering data to other platforms should not even be considered for digital archiving, which is inherently an effort made with durability in mind. 

[Omeka](https://omeka.org/) has been in existence for more than a decade, and is being developed by (or with the support of) the [same organisations](https://digitalscholar.org/) that did other excellent pieces of software, including [Zotero](https://www.zotero.org/) (a reference manager) and [Tropy](https://tropy.org/) (a software that facilitates organising pictures and document developed with historians in mind).[^1]

Omeka is being used by a large number of organisations and has a relatively solid user base and core funding. Fundamentally, it encourages using established metadata standards (in particular, [Dublin Core](https://dublincore.org/)), and allows to export data in an easily accessible machine readable format that, should the need arise, facilitate transfers to other platofrms or to other archives.[^2] I feel this is particularly important for a relatively small initiative such as ours: the ability to transfer systematically the digital archive to a new home may be fundamental to ensure its long-term existence. 

Besides, Omeka S is built around the concept of having archive items that can be added to different collections and different digital exhibitions (each with its own website), that seemed particularly well suited to an initiative such as ours including very different types of content.

## Metadata for different types of items: different but same

An old picture, a video clip, a bibliographic resource, a physical objects... they all need to be included in the archive consistently, yet there is no one set of metadata that is equally valid for all of them. 

The [Dublin Core](https://dublincore.org/) standards are flexible, but in order to ensure consistent data inputs and enable meaningful advanced search options there must be some consistency. 

This is enabled in Omeka S by "resource templates", and we ended up having about 20 of them. You can see how we used the, with the instructions for each use case, in our [online instruction manual](https://istruzioniarchiviomemoria.ecomuseovalledeilaghi.it/tipologiacontenuti.html).

This is one of the aspects that took some work in the early stages, but we are quite happy with the current set up. Archivists have usually a much more defined idea of how an item in their archive looks like, and they often have pre-defined hyerarchy... none of this applied to our case.

## Encouracing exploration of the digital archive

Some digital archives tend to resemble search engines: you open the home page and you have little more than a search box. If you are not looking for something specific but just curious this is sometimes frustrating, as random searches may bring only mildly interesting results. 

Beyond standard and advanced search, we propose three different ways to encourage exploration of the archive. All of them are somewhat readily available in Omeka S, but in each of these cases we ended up customising the default Omeka S experience-

### Digital exhibitions / mini-sites

Encouraging the creation of multiple sites is a key component feature of Omeka S, and its most distinctive feature from plain Omeka (without the S). In brief, you have a shared archive with all contents, and then you can make some of these contents separately available to additional sites, that can have a different layout, which is great for digital exhibitions or for showing better a specific type of items. 

For example, we created [a separate website](https://archiviomemoria.ecomuseovalledeilaghi.it/s/pubblicazioni-sulla-valle-dei-laghi/page/retrospettive) to present digital versions of local magazines distributed only in our valley. Keeping them separate has two advantages:

1. these magazines titles often include the name of the village: if someone looks for their own village's name in the main search box, they would likely find a bunch of magazines, rather than the wealth of old pictures that they're probably more interested in. 
2. Given that these are mostly pdf files, we used a different layout with full-width pdf embeds that would not be as fitting for other contents of the archive.

We currently have nine digital exhibitions, each of them inviting the visitor to explore a separate topic. Creating sites is very easy with Omeka S, but it is currently not as easy to showcase them from a single starting point. To give them more visibility, we used custom html to make them visible in the lower part of the [homepage of the main site of our archive](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/page/homepage), and we a slightly smaller reference to them just over the footer in the internal pages.

### Collections, item sets, hierarchies

Some archives have a distinct tree-like structure, which often reflects the physical location of an item. As our is a digital-only archive, we have no such inherently consistent structure to give to our collections. 

Some digital archives use tags to facilitate finding items that pertain to a specific topic. By default, Omeka S does not have tags, but its concept of item sets can be used somewhat similarly. Item sets, however, have no hierarchy, which we felt would have been useful to facilitate the exploration of the close to one hundred categories we identified.

This is the [final solution that we found](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/page/tematiche) (people not familiar with Omeka S may skip this paragraph). Basically, we set up a "[themes](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/page/tematiche)" page on the main archive site, with an "item showcase". Each of the about ten items included there corresponds to a macrocategory, e.g. "work". [The corresponding page](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/item/4896), is, technically, a normal Omeka S item, but that item has included in a field `dcterms:hasPart` about a dozen item sets. A custom layout for such pages in the theme showcases these item sets nicely (e.g. agriculture, trade, public works, etc.). Single items can thuse be put inside more than one "category", but there is still a hierarchical structure that is reflected in the data themselves and that if necessary can be systematically converted to other solutions if need be. While not breaking with logic of Omeka S, this pushes a bit what would be the default logic. 

We also included a separate page to explore the archive [by type of contents](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/page/tipologia), e.g. to see only old pictures or only documents... we accomplished this simply by including links as they would appear from an advanced search. 

### Exploring contents via maps

Omeka S has a `mapping` module that can easily be added to the default installation. As the vast majority of items in our archive either depict or refer to a specific location, just [browsing around the embedded map](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/map-browse) is a great way to explore contents. Many will be tempted to just go the map and see if there's some old picture of their street or their own house. 

The `mapping` module is great, but, perhaps unsurprisingly, it expects each item to have an *exact* location, which can be pinpointed on a map. In principle, this sounds good, but in pratice, we had to face an immediate problem: what to do with documents or pictures which generically refer to a whole village, rather than an exact location within that village?

I will clarify with an example. Let's suppose we have a picture of the main square of a village: everything is easy, I can pinpoint that picture to its exact location. But let us suppose that I have a postcard that shows a full village, or an old document that refers to the water system of a full village... what do I do? where do I put the pin? Should I put no pin at all, but then the content is invisible from the map, or should I put all such pins in the central square of the village (or some other arbitrary location, say, the place where OpenStreetMap sets the village centre, or the church)? But if so, I will end up with lots of pins in the central square of the village, and I won't be able any more to find actual pictures of that actual square.

Currently, [there does not seem to be a distinct answer to this issue in Omeka S](https://forum.omeka.org/t/generic-village-town-location-with-mapping-module/10086), so we ended up with a [custom solution](https://forum.omeka.org/t/generic-village-town-location-with-mapping-module/10086/5?u=giocomai): we added a custom metadata field to geolocated items that clarifies if the pinned location is exact or only approximate. In the [map browsing page](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/map-browse?fulltext_search=&property[0][joiner]=and&property[0][property]=304&property[0][type]=eq&property[0][text]=Collocazione+precisa), we added a link just under the map: if clicked, only items whose location is given precisely will be shown. 

With this setup, we have the best of both worlds... postcards showing a village can be included in the map, but there is no awkward over-crowding of pins in a specific location if one is interested in just exactly-placed pins.

### Cross-referencing items

We suspect that many curious visitors to our archive will reach one way or the other some item that they find interesting. In principle, this could be the end of their journey: they found something interesting, and now they'll just hit "back" and search for something else. However, with adequate use of cross-referencing items, it is possible to encourage this to be just the beginning of further exploration. 

A village in our valley had a small shop that now does not exist any more. We have [the shop itself](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/item/7851) as item, with a brief history of the shop and its owners mentioned in the description. A number of physical objects that were sold in the shop are listed in this page as they are recorded as "part of" the shop. A number of pictures in which the shop is visible are listed here as the shop is mentioned as "subject" in the relative page. The shop itself is part of the item set "shops", and has the name of the village as "location"... and the village itself is an Omeka item... clicking there, will show all items that have that village as location. All of the above are clickable and actively encourage further exploration of the archive. 

## Other small tweaks to Omeka S

### Items and media

Omeka S distinguishes between metadata of an item, and the metadata of a media associated with that item. Puzzling at first, the distinction is important: for example, we may want to keep reference of when a given material was scanned... but the date of the scan is something very different from the date when the original material was created. In other occasions, the media associated with an item simply reflects the item... we felt that in such cases replicating data could be confusing. Eventually, we found a [custom solution](https://forum.omeka.org/t/foundation-s-alpha-release-seeking-feedback/11053/7) whereby media metadata are shown if there's more than one media to an item or if a media has more that one metadata field filled. 

By default, media have their own separate pages. With our current theme on our main site, they should never appear to the user, but with other themes it is easy to end up on a media page, either via the item or because the "browse map" by default includes a link not only to the item page, but also to the media page. Unfortunately, from the media page there is no way to know which item the given item refers to... even more importantly, the media metadata are often very limited and context is missing. We reduce the risk that visitors who end up on [a media page such as this one](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/media/7855), are stuck without context, we [customised the theme](https://forum.omeka.org/t/media-page-and-link-to-respective-item/11224) in order to always include a link to the original item, and we customised the mapping module in order to leave only link to the item for those who explore the archive via the map. I believe both solutions should be incldued by default in Omeka S. 

### Dates and uncertain dates

If you have enabled the `NumericDataTypes` module, as you should, in order to have dates as actual dates rather than text strings, you may have some issues with the translation of month names if you're running Omeka S with a non-English language. I ended up implementing a [custom solution](https://forum.omeka.org/t/month-name-shown-in-english-on-item-page-in-spite-of-language-settings/9841/4?u=giocomai), but I still feel this could better be handled by the module itself.  

There is another aspect which is tricky about dates: what to do about uncertain dates. There does not seem to be an agreed standard on how to format these consistently, in particular in a way that still make the date searchable. Let's say that I have a picture that I cannot date exactly, but, through local knowledge, I can assess that it was taken between 1922 and 1936 (e.g. because of a combination of building and fountain that did not exist before or later). How do I write the date in the metadata? Here are the options:

- nothing: I do not know the exact date, so I do not include it. This would be a pity, because to me it may seem useless to leave a generic reference to such a wide range, but it may be very helpful for others.
- write the date as a text string, e.g. "1922/1936?": this is clear for humans, but is of no use for machines. So if somebody uses the advanced search and wants to find any photo done in a village in the 1920s, this will not appear, because advanced search will just see text there (and text cannot be "bigger than" 1920 or "smaller than" 1930).
- there's plenty of other solutions we've seen around that can be somewhat machine readable and human readable, e.g. 192x, or something, but none of them looked convincing. 

Eventually, we defined as a convention that in each case when we do not know an exact date, we enter twice the date field with the upper and lower boundary, clarifying in the description why this period was chosen. This solution has the great advantage of offering consistent results with researchers using advanced search: if they search for items dates between 1920 and 1930, this hypotetical item would show up, because 1922 is between those two dates. The researcher would then have to judge if it is relevant or not, but we think it is correct that it shows up in searches if it may satisfy the criteria. 

Finally, if we'll end up having to merge our archive with others, this solution makes it relatively easy to convert systematically this format into a string formatted in line with other possible standards.

### Website statistics

Omeka S, by itself, has no integrated solution for monitoring traffic of visitors. I have been sceptic about adding something like Google Analytics, because it would have forced us to add one of those odious cookie banners that degrades the user experience and, if done right, is mostly useless.[^3]
Eventually, we decided to go with a self-hosted instance of [Plausible](https://plausible.io/), which allows us to collect aggregated data on what are the most visited pages, but does not rely on cookies, never collects private data, and hence does not require any banner, but is still useful for us to have a broad idea of what people are most interested in, and we have some data that we can report to perspective donors. 


## Conclusions

An archive such as ours is a true community, inter-generational effort. It is already involving people from all age cohorts, from school children to the elderly, and gives us all an occasion more to talk with each other and find out more about our community, the place where we have grown up or live, and look differently at some of the sights we encounter every day. 

After more than a year into this adventure, we are very happy to have started this journey the way we did, and about choosing [Omeka S](https://omeka.org/) as a base for our digital archive. It did push us towards more consisent use of metadata as we hoped it would, and we now have a rich database with plenty of interrelated contents. The core team of developers and others in the community have been helpful in providing clarifications or small fixes [in the online forum](https://forum.omeka.org/). With a couple of thousands of items now part of the archive, we feel we are still at the beginning of this long-term endeavour. There may well still be some work to do on the visual aspect of the site, but overall we feel we have a solid foundation and an adequate technical infrastructure that allows for the consistent growth and availability of our archive for the foreseeable future.






[^1]: I am admittedly a big fan of all of these. I have used Zotero for more than a decade, and I have developed [a package for the R programming language](https://github.com/giocomai/zoteror) to interact with Zotero's APIs. I have contributed the [Italian translation of Tropy](https://twitter.com/tropy/status/1166789699270250498), and much of the translation of Omeka done in the last couple of years.
[^2]: Indeed, data are by default exposed in machine readable format, see [this is the machine-readable version](https://archiviomemoria.ecomuseovalledeilaghi.it/api/items/8052) of [this item page on the website](https://archiviomemoria.ecomuseovalledeilaghi.it/s/archivio/item/8052)
[^3]: Doing it right and legally in line with the GDPR would mean that one would enable Google Analytics only *after* the user explicitly clicks on a "yes, I want to be tracked" button, with an equally sized "no, I don't want to be tracked" next to it; just keeping on browing the website or closing the banner, as most people do, cannot legally be called consent. So if we do this right, our statistics would be almost useless, as few would click on the yes button, and we would still degrade the experience of all users by having an annoying banner. 