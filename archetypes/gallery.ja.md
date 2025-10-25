+++
title = 'Photo Gallery (20XX)'
date = '{{ now.Format "2006-01-02" }}'
categories = ['']
tags = ['']

draft = false
description = "mkt's photo gallery in 20XX"
summary = '📍 <Place-1>, <Place-2>, ...'

# Params
showDate = false
showDateUpdated = false
showAuthor = false
showPagination = false
showRelatedContent = false
+++


{{< carousel images="{DSC*.jpg,IMG_*.jpg}" aspectRatio="16-9" interval="2500" >}}


## ギャラリー

{{< gallery >}}
<img src="DSCXXXXX.jpg" alt="DSCXXXXX.jpg" class="grid-w33" />
{{< /gallery >}}


## マップ

{{< google-maps-2
    url="#"
    >}}


## 関連記事

{{< article link="/ja/blog/.../" >}}
