Big Kahuna is my webcam capture and filter tool. It's a mess, it's a work in development, it looks trippy. It's really flashy, always make sure you or no one on the other end is epileptic.

-Using Big Kahuna-
Run the appropriate app (under either win32 or win64)
It'll take the first available camera, GUI to pick is coming
Once it's running here are the keys:
q - turn on Bad Div
a - turn off Bad Div
Q - pause Bad Div cycle
A - resume Bad Div cycle
w - turn on Trail
s - turn off Trail
e - turn on Net
d - turn off Net
r - turn on Color Gravity
f - turn off Color Gravity
z - bring up ModeString menu (lets you set the filter parameters on the fly - this will crash the app if you cancel, so just close and reopen. Bug fix incoming)

Some notes:
Everything is duct tape and spit, be patient and don't blame me if things break
It's unlicensed, go nuts
Only one filter applies at a time, in this order of preference: Bad Div, Trail, Net, Color Gravity
Color Gravity switches color modes from RGB to HSB (and back when turing off). It turns off other filters in the process
While it's on, other filters can be turned back on and apply first
Color Gravity usually looks like crap anyways, but Bad Div can look pretty cool under HSB
I'd always love to see what you do with the filters, DM me on ig: @0bsol33t. 
I feel like I'm forgetting something, but I'm sure we'll figure it out. 
Oh, mode strings only work for BadDiv and Trail so the other two will remain awful for now.
Report issues on github if you find any, can't promise I'll fix them: https://github.com/read-0nly/ProcessingSandbox

Mode Strings:
Format is usually a bunch of numbers, semi-colon-delimited. After the last semi-colon, anything can be added, it's just ignored. Useful to label the strings. Here are some of my favorites:

BadDiv
100;1000;0.05;0;0;0.7;true; Pink and Gold (many layers, lots of action)
0.003;0.005;0.00001;0;0;0;true; LightNoise (looks like multicolor glitter highlights)
1.007;1.010;0.0001;180;-180;0.5;false; GhostTwin (crazy fire noise and too many faces)
2.03;2.07;0.0001;0;0;0.5;true; Acid Purples (purple and green and flashy)

HSB BadDiv
2.03;2.04;0.0000001;0;0;0.5;true; Pink and green and brown and kinda boring tbh. 
100;1000;0.0005;0;0;0.7;true; Purple and red and gray

Trail
0.999999999999999999;10;1;-4;3;150;0.8;0;  BigRed
0.99;500;1;-34;3;100;0.8;0; SmallEcho




