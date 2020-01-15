# Nixie Clock

This clock displays the time emulating a Nixie tube.
It is part of a contest called [Flutter Clock](https://flutter.dev/clock).
The emulation is not 100% perfect:
1. The unlit digits are in the right order, but I needed to bring the lit digit to the front for a better visual
2. The details could be better: some glare on the glass, etc.

The clock also displays weather information on the bottom section emulating a
VFD (Vacuum Fluorescent Display) section:
1. The style emulates pixel style segments
2. With a purchase of a 14 segment display font we could emulate a more LCD like VFD

The clock has a light theme and a dark theme.
See the [Analog Clock](../analog_clock) and [Digital Clock](../digital_clock)
for basic examples by the Google Flutter team.
