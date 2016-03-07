# strict_periods

This gem provides an array of *"strict"* ranges of consecutive known periods of time in a year, that is: not just by defining a *"size"*, such as `n.weeks` or `m.months`, instead it works by looking for ranges of periods according to the **definition** of *"week"* (starts with monday, ends with sunday), and the **definition** of *"month"* (first day is 1, last day is 28, 29, 30 or 31).

## Usage

`sp = StrictPeriod.new(anchor: '2016-04-03')`

### >>
`sp.next_week`

`sp.next_weeks`

`sp.next_weeks(n)`


### <<
`sp.previous_week`

`sp.previous_weeks`

`sp.previous_weeks(n)`

### Group results

`sp.grouped_next_weeks`

`sp.grouped_next_weeks(n)`

`sp.grouped_previous_weeks`

`sp.grouped_previous_weeks(n)`

### Optional constructor parameters
* `anchor: ('YYYY-MM-DD')`, default: current day
* `past_only: (true|false)`, default: true

## TODO
* add *"month"* as period
* manage sunday-monday weeks
* finalize specs

## Examples


```ruby
>> require 'strict_periods'
=> true

>> Time.now.utc
=> 2016-03-07 21:28:51 UTC

>> sp = StrictPeriod.new(anchor: '2016-04-03')
=> #<StrictPeriods::StrictPeriod:0x007fba5493cd60 @anchor=2016-04-03 00:00:00 UTC, @past_only=true, @week_picker=#<StrictPeriods::PeriodPickers::WeekPicker:0x007fba5493cb58 @steps=0, @anchor=2016-04-03 00:00:00 UTC, @past_only=true, @offset=0>>

>> sp.next_week
=> nil

>> sp.past_only = false
=> false

>> sp.next_week
=> ["2016-04-04", "2016-04-10"]

>> sp.next_weeks(2)
=> [["2016-04-04", "2016-04-10"], ["2016-04-11", "2016-04-17"]]

>> sp.previous_week
=> ["2016-03-21", "2016-03-27"]

>> sp.previous_weeks(3)
=> [["2016-03-07", "2016-03-13"], ["2016-03-14", "2016-03-20"], ["2016-03-21", "2016-03-27"]]

>> sp.past_only = true
=> true

>> sp.previous_weeks(3)
=> []

>> sp.previous_weeks(6)
=> [["2016-02-15", "2016-02-21"], ["2016-02-22", "2016-02-28"], ["2016-02-29", "2016-03-06"]]

>> sp.anchor = '2016-02-28'
=> "2016-02-28"

>> sp.next_week
=> ["2016-02-29", "2016-03-06"]

>> sp.previous_weeks(3)
=> [["2016-02-01", "2016-02-07"], ["2016-02-08", "2016-02-14"], ["2016-02-15", "2016-02-21"]]

>> sp.grouped_previous_weeks(3)
=> ["2016-02-01", "2016-02-21"]

>> sp.grouped_next_weeks(3)
=> ["2016-02-29", "2016-03-06"]
```

# License: MIT

Copyright (C) 2016 Giuseppe Lobraico

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.