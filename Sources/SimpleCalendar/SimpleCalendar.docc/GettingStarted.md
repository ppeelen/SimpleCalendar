# Getting Started with Simple Calendar

Setup the ``SimpleCalendarView`` with events and activities.

## Overview

A Simple Calendar is just that, _simple_, and should not take much to setup. The only thing it needs is a list of events with actions... that's it. In 
the Example project you can view how to setup a simple calendar quickly.

### `EventRepresentable`

An ``Event`` conforms to `EventRepresentable`, which means that if you have a different data structure you only need to make sure your model conforms 
to this protocol as well and you should be able to send it in into a ``SimpleCalendarView``. 

### `ActivityRepresentable`

As with `EventRepresentable`, ``Activity`` conforms to `ActivityRepresentable` which also means that you can have your own custom model and have it apply
to this protocol in order to use it in ``SimpleCalendarView``.

### Setting up a simple calendar

Given you have a list of events stored in `eventList`, the following code is all that is needed to show a calendar: 

```swift
SimpleCalendarView(
    events: eventList,
    selectionAction: .sheet
)
```
