# Simple Button Box

A simple button box, designed for my simracing rig. Includes 9 mechanical key switches and 2 3-way toggle switches.



![Screenshot](<Renders + Images/SimpleButtonBoxRender.png>)

![Screenshot](<Renders + Images/IMG_4494.png>)

I've wanted to have a button box for extra inputs on my simracing rig for awhile, so I finally made one!

The box uses 9 mechanical key switches (blue Cherry MX keys) so they feel tactile and satisfying. I also included two three-way toggle switches for additional inputs, totaling to about 13 inputs in total. While it's not a crazy amount, it's enough. The entire box is powered by an Arduino Pro Micro with a USB-C cable connection, making it easy to connect to (instead of micro-USB). I made this project so I could have something useful, but it's also a first for me. I started with a simple project to get the hang of designing projects like this from scratch, so that in the future I can build more complex things (maybe another button box!).
I designed the box to be clean and generic, not to flashy, so it'd fit with any rig and work with any car. I left enough space between buttons for labels and such, but made the buttons big enough so it's easy to press even with gloves in a rig! The buttons being tactile also helps when driving, when you need a sharp, tactile response from the button so you know how many inputs you've pressed.



Features:



* 9x Cherry MX Mechanical Key switches with custom 3D-printed keycaps
* 2x metal 3-way toggle switches (ON-OFF-ON)
* USB-C cable connection
* Removable top cover (for customization, painting, or fixing internal components etc.)
* Horizontal or vertical configuration



Assembly:



![Screenshot](<Renders + Images/Screenshot 2026-11-18 132856.png>)



The front case is a press fit, and it should have a tight enough tolerance to stay on. If not, you might have to try changing print settings, adding magnets, or gluing (unfortunately). I may add magnets in the future if I find that the friction fit doesn't work well.



For the front cover, you'll notice I have a carbon fiber weave pattern. I printed the front cover on a carbon-fiber weave texture PEI build plate, but you can also wrap it, paint it, or leave it bare if you can't make or don't want the texture.



Buttons are press fit onto the key switches, like normal key caps.



I used mill-max hotswaps, and designed the PCB with that in mind. Solder those on, then add the key switches on top. Ensure that the hotswaps are flush with the board!



Arduino Pro Micro slides in on the BOTTOM, upside down (see above).



Diodes MUST face away from button and towards the row wires, otherwise the matrix will not work.



Switches share ground and solder to pins 9, 10, 14, 15. Change the code if you want to change the input.



![Screenshot](<Renders + Images/Screenshot 2026-11-18 113445.png>)



![Screenshot](<Renders + Images/Screenshot 2026-11-18 113425.png>)



If you're printing out the PCB using a 3D printer and soldering + hot gluing the components on like I did, use these wiring diagrams to wire everything up with (ideally) insulated wires. Drill holes to go front/back as needed (I used a solder and burned two holes through, for the row and column wires).



If you're printing/using the PCB:



![Screenshot](<Renders + Images/Screenshot 2026-11-18 113838.png>)



For soldering order, I soldered the Arduino Pro Micro, then the diodes, then the hotswaps. Then add wires (if you're not using a PCB).

NOTE!!: If you're using the plastic PCB file, you have to be careful about soldering! I solder at 350-400 degrees, the plastic (PLA) will melt almost immediately upon contact with the iron. In order to solder, heat up the METAL component, add solder, then pull away the soldering iron relatively quickly It may take a few tries.

Once everything is soldered, you can slide the PCB onto the mounting pegs in the bottom case. You can add hot glue, superglue, or whatever you need. Just make sure to secure the board.


For the toggle switches, take off the hex nut and washer, slide the switch through the hole, screw on the hex nut and washer (washer on bottom), then turn the switch body while holding the hex nut> Or use a wrench to secure the hex nut. You can do this either vertically or horizontally, depending on how you want to mount the box (so the switches should always be up, but relative to the short side of the box). I mounted the box vertically, so the switches pointed towards/away from the buttons. You can also do it perpendicular (horizontal button box mounting). 

Once the toggle switches are on the lid, solder them to the PCB board.

![Screenshot](<Renders + Images/IMG_4489.png>)

I mentioned earlier that the lid is press fit. I ended up finding that that did not work! So I drilled two holes on either end. I drove a M2.5 x 8 screw in. It should be a pretty snug fit for the screw. It required a bit of force to screw in. If you want to use magnets or something else, screws are not necessary, but I 100% recommend them.

I also added hot glue around the PCB supports, just to make sure that those fragile supports don't bend or snap when unplugging/plugging the USB-C cable. But again, optional. 

If you find that the buttons don't spring back up, take a pen spring or similar sized springs, use pliers to expand their diameter, then slide them over the 3D printed buttons. I found that it made the buttons feel squishy, so I didn't end up using them> but if you like the added stiffness, then add them. It also might work better with a proper PCB, so I think that is important to note as well.

VERY IMPORTANT: Please be careful when gluing the PCB in, because the USB-C cable might not be able to reach inside if you do it wrong!!

Also note that I did not secure the PCB board, finding that it was ok, but you might need to. The electrical tape I put on the toggle switches ended up being stiff enough to push the board into place, so i found it to be ok. But again, you might need it.

I also found that if the switches are tilted at all and the buttons rub against the lid, you can hold the switch in place until it's straight, then add hot glue to secure it. But again, not sure if you'll need that with a regular PCB.

One FINAL thing: I printed the lid at 100.5%, so I'd recommend doing that, though slightly lower might be ok (my XY compensation was about -2.5mm, so take that into account).

Ok that's all, thanks for reading!


Firmware:



Check "External" folder for libraries, it's important.

Open Arduino IDE, open the sketch, then go to "Sketch>Include Library>Add .ZIP Library" and add the Joystick library.
Select "Tools>Board>Arduino AVR Boards>Arduino Leonardo"
Make sure you select the right COM port, then compile and upload.

If it doesn't upload (like it did for me), try double-clicking reset on the board (or connecting GND and RST twice quickly) right before Arduino IDE uploads.

![Screenshot](<Renders + Images/ IMG_4497.png)


Credits:

Claude gave me advice for writing firmware
Claude also wrote an upload file to fix an issue on my computer where Arduino wasn't uploading the sketch. I originally included the file in the repo but removed it after further evaluation. Everything currently in the repo is mine.

See "External" folder for all the files, models, and libraries I used!

