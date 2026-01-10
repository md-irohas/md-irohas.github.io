+++
title = '🧳 Trip Recap: ... (March, 20XX)'
date = '{{ now.Format "2006-01-02" }}'
categories = ['Blog (Trip Recap)']
tags = ['Trip Recap', '<Prefecture>']

isCJKLanguage = false
description = '🚙 A blog post about my trip to ... and ... in Month 20XX.'
summary = '📍 <Place1>, <Place2>, ...'

draft = false

# Params
+++


## Story

Some sentences...

{{< google-maps-2
    url="#"
    >}}


## Timeline

{{< timeline >}}


{{< timelineItem
    header="Tokyo (Home) → XXX"
    icon="car-front-fill" >}}
...

<br>

{{< google-maps-2
    url="#"
    width="480"
    height="360"
    >}}

{{< /timelineItem >}}


{{< timelineItem
    header="Somewhere City"
    icon="camera-fill"
    >}}
...

<ul>
    <li>Web site: <a href="#" target="_blank">http://.../</a></li>
</ul>

{{< figure
    src="IMG_XXXX.jpg"
    alt="IMG_XXXX.jpg"
    caption="Caption"
    class="w50"
    >}}

<br>
<br>

{{< article link="/blog/202X-XX-XX-tripphoto-some-slug/" >}}

{{< /timelineItem >}}


{{< timelineItem
    header="XXX → Tokyo (Home)"
    icon="car-front-fill"
    >}}
...
{{< /timelineItem >}}


{{< /timeline >}}


## Gallery

### iPhone 12 mini

{{< gallery >}}
<img src="IMG_XXXX.jpg" alt="IMG_XXXX.jpg" class="grid-w33" />
<img src="IMG_XXXX.jpg" alt="IMG_XXXX.jpg" class="grid-w33" />
<img src="IMG_XXXX.jpg" alt="IMG_XXXX.jpg" class="grid-w33" />
{{< /gallery >}}


## Map

{{< google-maps-2
    url="#"
    >}}

{{< text-right >}}
\* The route is approximate.
{{< /text-right >}}


## Change History

- 202X/XX/XX: First version.
