+++
title = '📸 Trip Photo: XXX (Month, Year)'
date = '{{ now.Format "2006-01-02" }}'
categories = ['Blog (Trip Photo)']
tags = ['Trip', 'Photo', '<Prefecture>', '<Kind-of-Place>']

isCJKLanguage = false
description = '📝 A blog post about my photos I took at XXXX in Month 202X. <Additinal-Text>'
summary = '📍 <Place1>, <Place2>, ...'

draft = true

# Params
googlePhotoUrl = ''
googleDriveUrl = ''
+++


## Story

In \<Month\> \<Year\>, ...


### \<Place\>

> The main story includes maps, photos, and links.

{{< google-maps-2
  url=""
  >}}

{{< figure
    src="IMG_XXXX.jpg"
    alt="IMG_XXXX.jpg"
    caption="Photo Caption"
    class="w50"
    >}}


## Gallery

{{< creative-commons lang="en" license="by-nc-sa" >}}

{{< google-photos-album lang="en" >}}


### iPhone 12 mini

{{< gallery >}}
  <img src="IMG_XXXX.jpg" alt="IMG_XXXX.jpg" class="grid-w50" />
  <img src="IMG_XXXX.jpg" alt="IMG_XXXX.jpg" class="grid-w50" />
{{< /gallery >}}


### α6500

{{< gallery >}}
  <img src="DSC0XXXX-Enhanced-NR.jpg" alt="DSC0XXXX-Enhanced-NR.jpg" class="grid-w60" />
  <img src="DSC0XXXX-Enhanced-NR.jpg" alt="DSC0XXXX-Enhanced-NR.jpg" class="grid-w40" />
{{< /gallery >}}

{{< google-drive-photo-raw lang="en" >}}


## Map

### \<Site\>

{{< google-maps-2
  url="#"
  >}}


### Sites

{{< google-maps-2
  url="#"
  >}}


## Change History

- 2024/XX/XX: First version.
