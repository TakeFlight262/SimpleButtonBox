# Simple Button Box

A simple button box, designed for my simracing rig. Includes 9 mechanical key switches and 2 3-way toggle switches.



!\[Screenshot](<Renders/SimpleButtonBoxRender.png>)



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



!\[Screenshot](<Renders/Screenshot 2026-11-18 132856.png>)



The front case is a press fit, and it should have a tight enough tolerance to stay on. If not, you might have to try changing print settings, adding magnets, or gluing (unfortunately). I may add magnets in the future if I find that the friction fit doesn't work well.



For the front cover, you'll notice I have a carbon fiber weave pattern. I printed the front cover on a carbon-fiber weave texture PEI build plate, but you can also wrap it, paint it, or leave it bare if you can't make or don't want the texture.



Buttons are press fit onto the key switches, like normal key caps.



I used mill-max hotswaps, and designed the PCB with that in mind. Solder those on, then add the key switches on top. Ensure that the hotswaps are flush with the board!



Arduino Pro Micro slides in on the BOTTOM, upside down (see above).



Diodes MUST face away from button and towards the row wires, otherwise the matrix will not work.



Switches share ground and solder to pins 9, 10, 14, 15. Change the code if you want to change the input.



!\[Screenshot](<Renders\\Screenshot 2026-11-18 113445.png>)



!\[Screenshot](<Renders\\Screenshot 2026-11-18 113425.png>)



If you're printing out the PCB using a 3D printer and soldering + hot gluing the components on like I did, use these wiring diagrams to wire everything up with (ideally) insulated wires. Drill holes to go front/back as needed (I used a solder and burned two holes through, for the row and column wires).



If you're printing/using the PCB:



!\[Screenshot](<Renders\\Screenshot 2026-11-18 113838.png>)



For soldering order, I soldered the Arduino Pro Micro, then the diodes, then the hotswaps. Then add wires (if you're not using a PCB).

NOTE!!: If you're using the plastic PCB file, you have to be careful about soldering! I solder at 350-400 degrees, the plastic (PLA) will melt almost immediately upon contact with the iron. In order to solder, heat up the METAL component, add solder, then pull away the soldering iron relatively quickly It may take a few tries.

Once everything is soldered, you can slide the PCB onto the mounting pegs in the bottom case. You can add hot glue, superglue, or whatever you need. Just make sure to secure the board.



Firmware:



Check "External" folder for libraries, it's important.

Open Arduino IDE, open the sketch, then go to "Sketch>Include Library>Add .ZIP Library" and add the Joystick library.
Select "Tools>Board>Arduino AVR Boards>Arduino Leonardo"
Make sure you select the right COM port, then compile and upload.

If it doesn't upload (like it did for me), try double-clicking reset on the board (or connecting GND and RST twice quickly) right before Arduino IDE uploads.
If that doesn't work, go to the firmware folder, read the README.md in that folder, and follow the instructions (I had Claude write the script to fix the uploading issue).



Credits:
See "External" folder for all the files, models, and libraries I used!

