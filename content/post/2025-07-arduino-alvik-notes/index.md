---
title: Using Arduino Alvik on Fedora Linux
author: ''
date: '2025-07-13'
categories:
  - tech
tags:
  - arduino
  - alvik
  - micrOpython
subtitle: ""
summary: ''
authors: []
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

[THIS IS A DRAFT DOCUMENT, POSTED FOR REFERENCE, IT MAY BE UPDATED]

This is mostly a collection of scattered notes. I place them here, as I use the device only occasionally and from different laptops, hence I always end up wasting time troubleshooting issues. The most annoying - at least on Linux - are port permission issues, as IDEs and such just give generic errors and forums will send you through all sorts of unrelated side quests for resetting the device, etc. If you're on Linux, before trying anything else, just check the "Fix port issues" section below.

## Preliminary issues

### Battery

- check battery status:
  - green led means battery fully charged
  - blinking red light means battery charging
  - no lights on, and there's a blinking orange light next to the QWIIC connector: faulty battery

### Connecting

#### Fix port issues

On Fedora, at least, the default user will not have access to the needed ports. 

You can see by first checking which groups have access to the port:

```
ls -l /dev/ttyACM*
```

And then see which groups your user is a member of:

```
groups
```

You will likely see that your user is not part of `dialout`.

So add yourself to `dialout`, log out, and log back in. 

```
sudo usermod -aG dialout $USER
```

This should fix it even after reboot. 

Notice that you may still have issues if you rely on software installed via Flatpaks. See [this post on the Fedora forums](https://discussion.fedoraproject.org/t/how-to-add-myself-to-the-dialout-group/24147?replies_to_post_number=7) for reference.

For a quick fix, consider just giving full access to that port, if you feel there are no other concerns `sudo chmod a+rw /dev/ttyACM0`



#### Mlink
https://mblock.makeblock.com/en/download/mlink/

### Updating the firmware

There are apparently two ways to go about it:

- through the [dedicated web page](https://alvikupdate.arduino.cc/) using a supported browser (e.g. Chrome, Firefox not supported)
- through the Arduino IDE web page

## User manuals and tutorials

### User manual

https://docs.arduino.cc/tutorials/alvik/user-manual/

### Getting Started

- https://docs.arduino.cc/tutorials/alvik/getting-started/


## Arduino IDE

### Arduino Lab for Micropython

https://labs.arduino.cc/en/labs/micropython



There are two main versions, one often found simply as Arduino IDE, the other as Arduino IDE V2. Both are available as Flatpaks via Flathub.

### Arduino IDE 1

https://support.arduino.cc/hc/en-us/articles/360019833020-Download-and-install-Arduino-IDE

## Troubleshooting

### MicroPython installer

https://docs.arduino.cc/micropython/first-steps/install-guide/

Available on the GitHub repo, compiled as a package for Debian, but not for Fedora; can be built from source:
https://github.com/arduino/lab-micropython-installer
