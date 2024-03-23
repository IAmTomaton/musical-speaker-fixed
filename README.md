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

_Insert video here when I do it_

# Installation

The size of the original mod sound files is too large for the mod portal, so the mod will be posted there completely without sound files.
- If you want to use your sound files, then place them in the mod folder and write the paths to them in the `script/sound-data.lua` file.
- If you want to use sounds from the parent mod, then download the mod archive containing sound files from the link (_Put link here_). Then unzip it into your mod folder (this will also overwrite the `script/sound-data.lua` file).

# Caveats
- For right now, enabled and reset condition comparison is limited to `> 0`.
	- If you want a different condition, use a decider combinator to translate the condition.
- For musical speaker sounds are _not_ pre-loaded by the game.
	- This means that there will be a slight-but-noticeable delay the first time each note is played.
	- If you're in a situation where you need minimal delay (ie recording), play your composition once ahead of time to warm up the sounds.
 
