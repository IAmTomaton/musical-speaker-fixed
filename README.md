# musical-speaker-fixed

A Factorio mod that provides an enhanced version of enhanced version of the programmable speaker, mostly intended for music production. The mod is based on the original mod [musical-speaker](https://github.com/Xcelled/musical-speaker).

The set of sounds corresponds to the original mod.

Features:
- Sounds stop when the speaker is disabled via circuit network (Vanilla programmable speaker continues playing).
- Control volume, category, instrument and note via circuit network.
- The settings can be set at any time, while the original can only set during the tick when a note starts playing.
- The reset setting allows you to restart sound playback without disable the speaker.
- Some bugs fixed.

![](./images/img1.jpg)

# Example usage

An example of work can be seen in this [video](https://youtu.be/hk3BCiMDQDs)

[![video](https://img.youtube.com/vi/hk3BCiMDQDs/0.jpg)](https://www.youtube.com/watch?v=hk3BCiMDQDs)

# Installation

The size of the mod's source sound files is too large for the mod portal, so the mod will be hosted there with only one musical instrument.
- If you want to use your sound files, then place them in the mod folder and write the paths to them in the `script/sound-data.lua` file.
- If you want to use all the sounds from the parent mod, then download the mod release from [github](https://github.com/IAmTomaton/musical-speaker-fixed/releases/tag/v1.0.0).

# Caveats
- For right now, enabled and reset condition comparison is limited to `> 0`.
	- If you want a different condition, use a decider combinator to translate the condition.
- For musical speaker sounds are _not_ pre-loaded by the game.
	- This means that there will be a slight-but-noticeable delay the first time each note is played.
	- If you're in a situation where you need minimal delay (ie recording), play your composition once ahead of time to warm up the sounds.
 
