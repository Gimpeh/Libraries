GimpOCD - Overseeing, Controlling, Directing
-----------------

This is still under development.

Real installers will be available on release to make parts of installing this easy, and do things like autorun on the battery monitor and such.

Expect Bugs. You have been warned!

-----------------

Made for the Gregtech New Horizons modpack (minecraft)

Overview
-----------------

This is a UI for the Opencomputers Glass

Features;

Battery Widget - for monitoring power metrics

Item Monitoring - Interface with an ME system and allows selecting Items to keep track of (display on the HUD coming soon)

Level Maintaining - Like an AE level maintainer but with much more configuration available

Gregtech Machine/Multi monitoring/controlling - Displays if machines are disabled/enabled, if they are running, and allows turning them on/off. (Mostly back on due to power loss or something stupid =])

Highlighting Disabled machines - Creates Red Dots at Disabled machines' locations if enabled.

Highlighting Machines Requiring Maintenance - Same as above

More features coming soon!

Setup
----------------

The current required systems are an opencomputers server and a supporting opencomputers computer (referred to as subsystem).

-----------

Recommended for the server;

Creative APU

4 Memory(Tier 3.5) OR BETTER

I'd be surprised if it required anything more than a Tier 1 HDD, unless you try to capture the output. Then it will easily fill a RAID array with 3 tier 3's

A Wireless Card

An Internet Card

---------------

Recommended for the subsystem;

Tier 3 APU

1 Memory(Tier 3.5) will do it. Almost certainly requires less with 1 battery connected.. Almost certainly requires more with 100 batteries connected

A Hard Drive

A wireless card

Optionally, add a redstone component and configure the battery monitoring program for generator control

Optionally an internet card for the downloader

---------------

The subsystem needs to be connected to whatever battery (batteries) you wish to monitor. Any batteries, in any combination, technically in almost any amount.

Optionally connect its redstone component to a generator (containing the relevant cover) and configure the battery_monitor.lua file to have it control generators. This is not recommended however.. other ways are always more reliable than any opencomputers system.

![image](https://github.com/user-attachments/assets/ad2236cf-cdde-46f9-95fc-33cc567d678a)

change to

![image](https://github.com/user-attachments/assets/bf45b0f7-1756-476c-8cd2-38dc2b04b2b3)

setting the number to whatever number required.. almost certainly more than the number in the picture =].

```
wget https://raw.githubusercontent.com/Gimpeh/GimpOCD/semi-stable/Supporting%20Systems/Battery_Monitor.lua battery_monitor.lua
```

run it from the directory you downloaded it from with `battery_monitor.lua` from the command line

-----------------

The Server requires the following additional components;

1 ME Interface that is connected to the system to be monitored

1 Glasses Controller

probably 2 dozen opencomputers capacitors (Or you could just edit the openglasses config to make it not consume a buttload of energy)

------------------

The server also requires you to create a groups.config file. Eventually systems for creating it will be included and run during install.

![image](https://github.com/user-attachments/assets/87a85765-c81f-4723-8ff8-833f2d497198)

The system in the image has 2 groups specified in its groups.config file

Active1 with 26 machines and Distillation with 17 machines.

That means that 26 machines literal coordinate location in the world fall within the range specified under Active1's entry.


First, create the file
```
edit /home/programData/groups.config
```

ChatGPT should be able to help you create the file if this part is confusing to you. Just paste the following into a chat with it;
```
This file is for specifying coordinate ranges. The start coordinates should always be the lower of the 2 values. 
The file should contain a lua array structured as follows (with a prepending return statement);

return {
  [1] = {
    name="<group name>",
    start={
      x=<The starting x coordinate for the groups coordinate range>,
      y=<The starting y coordinate for the groups coordinate range>,
      z=<The starting z coordinate for the groups coordinate range>
    },
    ending={
      x=<The ending x coordinate for the groups coordinate range>,
      y=<The ending y coordinate for the groups coordinate range>,
      z=<The ending z coordinate for the groups coordinate range>
    }
  }
}

So for example;

return {
  [1] = {
    name="All",
    start={
      x=-100000000,
      y=0,
      z=-100000000
    },
    ending={
      x=1000000000,
      y=1000,
      z=1000000000
    }
  },
  [2] = {
    name="none",
    start={
      x=0,
      y=0,
      z=0
    },
    ending={
      x=0,
      y=0,
      z=0
    }
  }
}
```
The example will work, it will create 2 groups.

All will almost certainly contain all of your connected gregtech machines (if not then MAD props)

none will not contain any and is provided merely to demonstrate adding another entry.

----------------------

after that install GimpOCD on the server;

```
wget https://raw.githubusercontent.com/Gimpeh/GimpOCD/semi-stable/very_basic_terrible_installer.lua d && d
```

you can now run it with the following command from any directory;

```
GimpOCD.exe
```

and thats should be it...
other than setting the hotkey for opening the overlay.

If the battery widget disappears after setting its location and closing the overlay, do not despair.

Just open and close the overlay and it should be resolved. And it shouldnt happen again.
