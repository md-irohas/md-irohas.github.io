+++
title = 'Visualizing Year/Month/Day Progress in Grafana'
date = '2025-11-30'
categories = ['Blog (Tech)']
tags = ['Prometheus', 'Grafana']

isCJKLanguage = false
description = "I've put together a set of PromQL queries for visualizing how much of this year, this month, and today has passed using Grafana and Prometheus. The Enlgish version will be published soon."
summary = "I've put together a set of PromQL queries for visualizing how much of this year, this month, and today has passed using Grafana and Prometheus. The Enlgish version will be published soon."
showReadingTime = false

draft = false

# Params
+++

{{< katex >}}

{{< devto-link url='https://dev.to/mkt/visualizing-yearmonthday-progress-in-grafana-1mf4' >}}

---

As of writing this post (2025/11/30), apparently around 90% of this year has already passed.

{{< x user="year_progress" id="1993184119292149949" >}}

I use Grafana and Prometheus for system monitoring, and I thought it would be cool to see "How much of this year has passed?" directly on my Grafana dashboard.

So I built it!

While I was at it, I decided to show not only the progress of this year but also the progress of this month and today.


## TL;DR

Here's what the panel looks like:

![Time Progress Panel](featured.png)

After some trial and error, I managed to create this using only Grafana and Prometheus (PromQL), which I already use every day.

The PromQL queries to calculate each value (for UTC) are as follows:


**This Year (UTC)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "5_this-year-progress-utc.promql" >}}

**This Month (UTC)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "3_this-month-progress-utc.promql" >}}

**Today (UTC)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "1_today-progress-utc.promql" >}}

If you want to display progress in a timezone other than UTC, simply add the appropriate offset (in seconds) to your queries.

For example:

- UTC+9 (Japan Standard Time; JST): add `3600 * 9` (= 32400) seconds
- UTC+2: add `3600 * 2` (= 7200) seconds
- UTC-5: add `3600 * -5` (= -18000) seconds

Replace the offsets in the queries to match your local timezone.

Below are JST examples:

**This Year (JST)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "6_this-year-progress-jst.promql" >}}

**This Month (JST)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "4_this-month-progress-jst.promql" >}}

**Today (JST)**
{{< gist "md-irohas" "e8289be61c554d0b59fdd36fa085f5fe" "2_today-progress-jst.promql" >}}


If you know a better way to do this, let me know 🙇‍♂️


## Test Environment

Here's the environment I used for testing:

- Ubuntu Server 24.04
  - Grafana: 12.3.0
  - Prometheus: 2.45.3 (the version available via apt on Ubuntu 24.04)

*Note: I used Prometheus 2.x for testing. Things might be simpler with 3.x, but I haven't tried yet.*


## Calculation Formulas

To visualize how much of today, this month, and this year has passed (which I'll call the "progress"), you need to calculate these values.

The formulas themselves are pretty straightforward: subtract the unixtime at the start of day/month/year from the current unixtime, then divide by the total seconds in day/month/year.

So, if you can express PromQL queries that match the following formulas, you're good to go:

$$
\text{Today's Progress (\%)} 
= \frac{\text{Current Unixtime} - \text{Unixtime at Today's 00:00}}{3600 \times 24} \times 100
$$

$$
\text{This Month's Progress (\%)} 
= \frac{\text{Current Unixtime} - \text{Unixtime at 00:00 of the 1st Day of Month}}{3600 \times 24 \times \text{Days in Month}} \times 100
$$

$$
\text{This Year's Progress (\%)} 
= \frac{\text{Current Unixtime} - \text{Unixtime at 00:00 of Jan 1st}}{3600 \times 24 \times \text{Days in Year}} \times 100 \\
$$

*Note: I didn't account for daylight saving time (DST) here.*


## PromQL Queries

Let's implement the formulas above using Prometheus Query Language (PromQL), which provides a number of helpful built-in functions.

- Prometheus docs: https://prometheus.io/docs/prometheus/latest/querying/functions/  
  (*Note: Prometheus 2.x and 3.x differ in some literals and syntax. Be careful!*)

One thing to keep in mind: PromQL's time functions operate in UTC. If you want values in your local timezone, you must add an offset manually.

The following explanations are a bit log, so if you just want the final queries, feel free to scroll back to the TL;DR section.


### Today's Progress

First, let's calculate today's progress.

$$
\text{Today's Progress (\%)} = \frac{\text{Current Unixtime} - \text{Unixtime at Today's 00:00}}{3600 \times 24} \times 100
$$

In PromQL, you can get the current unixtime by the `time()` function.

You can also calculate today's 00:00 unixtime using the `day_of_year()` function, but you don't need to. The number of seconds since 00:00 can be calculated by taking the remainder of the unixtime divided by 86400 (`= 3600 * 24`).

So we can use modulo directly.

```promql
# UTC
(time() % (3600 * 24)) / (3600 * 24)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-1_today-progress-utc-promql

If you want to display the value in your local timezone, add the appropriate offset in seconds. For example, for JST (UTC+9), add `3600 * 9` (= 32400) seconds.

```promql
# JST
((time() + 3600 * 9) % (3600 * 24)) / (3600 * 24)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-2_today-progress-jst-promql

Grafana can multiply by 100 for percentage formatting, so you can leave the raw ratio as-is.


### This Month's Progress

Next, this month's progress.

$$
\text{This Month's Progress (\%)} = \frac{\text{Current Unixtime} - \text{Unixtime at 00:00 of the 1st Day of Month}}{3600 \times 24 \times \text{Days in Month}} \times 100
$$

Getting the current unixtime is the same as before, but the tricky part is "Unixtime at 00:00 of the 1st Day of Month" and "Days in Month".

Obviously, the number of days in a month varies, so you can't use modulo like I did for today's progress.

Fortunately, PromQL provides the `days_in_month()` function for the latter.

Then, how do you get the unixtime for the 1st day of the month?

You don't need to calculate it directly. PromQL has a `day_of_month()` function that returns the current day of the month, so you can write the numerator as:

```promql
(day_of_month() - 1) * (3600 * 24)  # Seconds for previous days
+ (time() % (3600 * 24))            # Seconds for today
```

So, the query for this month's progress looks like this:

```promql
# UTC
(
  ((day_of_month() - 1) * (3600 * 24)) + (time() % (3600 * 24))
)
/
(
  days_in_month() * (3600 * 24)
)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-3_this-month-progress-utc-promql


For other timezones, you need to make sure `day_of_month()` and `days_in_month()` are calculated in your local timezone, not UTC. These functions accept a unixtime (as a vector) as an argument, so you can use your offset-adjusted time.

```promql
# JST
(
  ((day_of_month(vector(time() + 3600 * 9)) - 1) * (3600 * 24)) + ((time() + 3600 * 9) % (3600 * 24))
)
/
(
  days_in_month(vector(time() + 3600 * 9)) * (3600 * 24)
)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-4_this-month-progress-jst-promql

It's a bit tricky, but it works!


### This Year's Progress

Finally, this year's progress.

$$
\text{This Year's Progress (\%)} = \frac{\text{Current Unixtime} - \text{Unixtime at 00:00 of Jan 1st}}{3600 \times 24 \times \text{Days in Year}} \times 100
$$

Just like with the month, you can use the `day_of_year()` function to get the number of seconds since the start of the year:

```promql
(day_of_year() - 1) * (3600 * 24) # Seconds for previous days
+ (time() % (3600 * 24))          # Seconds for today
```

The only missing piece is "Days in Year".

Years normally have 365 days, but leap years have 366. If you've ever taken a programming class, you've probably written an if-else statement to check for leap years. But PromQL doesn't have if-else clause, and there's no handy `days_in_year()` function.

So, I asked ChatGPT for help, and it suggested the following code:

```promql
# PromQL to calculate the number of days in the year
365
+ clamp_max(
  (
    (
      ((floor(vector(time()) / 31557600) + 1970) % 400) == bool 0
    )
    +
    (
      (((floor(vector(time()) / 31557600) + 1970) % 4) == bool 0)
      *
      (((floor(vector(time()) / 31557600) + 1970) % 100) != bool 0)
    )
  ),
  1
)
```

31557600 represents 365.25 days * 86400 seconds, an approximation for a year. By dividing the unixtime by this value, you can get the year difference since 1970.

Also, you can use the `bool` modifier to simulate conditional logic. Comparisons return true/false as 1/0, so you can mimic simple if-else behavior.

Interesting... but since it's an approximation, there might be some error (I haven't checked how much it is).

After thinking a bit, I realized we can use PromQL's `day_of_year()` function to check for leap years. Specifically, if it is a leap year, the length of the year is 366 days, so if you calculate `day_of_year()` at the same time 365 days (\(= 3600 \times 24 \times 365\) seconds) later, the value must be different from the current value.

So, you can calculate the number of days in the year like this:

```promql
# PromQL to calculate if this year has 365 or 366 days
365
+
(
  day_of_year() != bool day_of_year(vector(time() + (3600 * 24 * 365)))   # Returns 1 or 0
)
```

The final query for this year's progress is:

```promql
# UTC
(
  ((day_of_year() - 1) * (3600 * 24)) + (time() % (3600 * 24))
)
/
(
  (365 + (day_of_year() != bool day_of_year(vector(time() + 3600 * 24 * 365)))) * 3600 * 24
)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-5_this-year-progress-utc-promql


It's a bit hard to read, but the same logic applies for any timezone. Just adjust the offset in the query to match your local timezone.

```promql
# JST
(
  (day_of_year(vector(time() + 3600 * 9) - 1) * 3600 * 24) + ((time() + 3600 * 9) % (3600 * 24) )
)
/
(
  (365 + (day_of_year(vector(time() + 3600 * 9)) != bool day_of_year(vector(time() + 3600 * 9 + 3600 * 24 * 365)))) * 3600 * 24
)
```

- GitHub Gist: https://gist.github.com/md-irohas/e8289be61c554d0b59fdd36fa085f5fe#file-6_this-year-progress-jst-promql

With this, you have all the PromQL queries you need for visualization.

I haven't thoroughly tested all edge cases, so if you spot a bug, please let me know!


## Visualizing in Grafana

Once the queries are ready, all that's left is to create your favorite panel in Grafana.

To make a panel like the screenshot above, follow these steps:

1. Add a new panel to your dashboard.
1. Select "Bar gauge" as the visualization type.
1. Choose Prometheus as the data source (assuming you've already added it).
1. Paste the queries for year, month, and day progress. Set the legend to "This Year", "This Month", and "Today" respectively.
1. In the right sidebar, configure:
    - Bar gauge:
        - Orientation: Horizontal
        - Display mode: Retro LCD
    - Standard options:
        - Unit: Misc / Percent (0.0-1.0)
        - Min: 0
        - Max: 1

This should give you a panel that looks like this:

![Time Progress Panel](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pfarvz0hff5d6qx4c31b.png)


## What About Other Datasources?

You can probably do something similar with other datasources, but there are too many to test.

If you use NodeExporter or Pushgateway, you could create your own custom metrics. PostgreSQL can handle pretty complex SQL, so you could probably calculate it there too (though setting up PostgreSQL just for this might be overkill).


## Summary

This article walks through how to visualize the progress of year, month, and day using Grafana + Prometheus.

Writing these queries in a DSL like PromQL was a fun little puzzle.

If you try this setup or come up with a cleaner approach, I'd love to hear about it!


## References

- Prometheus: https://prometheus.io/docs/prometheus/latest/querying/functions/


## Changelog

- 2026/09/21: Republished from dev.to.
- 2025/11/30: First version.
