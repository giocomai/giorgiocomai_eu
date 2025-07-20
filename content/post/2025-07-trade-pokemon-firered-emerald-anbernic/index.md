---
title: Trading Pokemon between FireRed and Emerald, playing on Anbernic 35xx
author: ''
date: '2025-07-13'
categories:
  - tech
tags:
  - pokemon
  - emulator
subtitle: "There's no way, as far as I know, to connect directly two Anbernic 35xx devices. But you can move the save files to a computer, do the transfer there, and take the saved file back. If you do the right steps."
summary: ''
authors: []
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

First things first: depending on when exactly you got your device or transferred ROMs on it, there may be something not quite right with the Pokemon Fire Red ROM that comes with the Anbernic. If you just play on the Anbernic, all is fine, but the save files (.sav) and the ROM itself tend to cause issues on other emulators, which we need to finalise the Pokemon transfer. More specifically, you won't be able to save, as it will get stuck when you try do so); also, it [won't load into PKHeX](https://projectpokemon.org/home/forums/topic/64220-leafgreen-sav-file-from-anbernic-rg35xx-not-loading-into-pkhex/), if you're into that kind of thing. Fear not: even if you are in this scenario, you can still move to a more standard save file and ROM without losing any of your progress.


### Step 1: check if you have the problematic ROM

There's an easy way to see if you've got the more problematic ROM that, at least for a while, came stock with the Anbernic 35xx: if the `.sav` file is about 64kB in size (65536 bytes), then you have the problematic one. If it's twice that size, at about 128kb (131072 bytes), you're most likely on a more standard ROM and you can skip to the next section. 

If you've got the problematic ROM, you'll need to to two things:

- take a more standard ROM, [such as this one](https://visualboyadvance.org/gba-roms/pokemon-fire-red/), and use it instead. It will work nicely on the Anbernic, and you just need to make sure that the new ROM and the .sav files of your game are named exactly the same and are located in the `ROMS/Roms/GBA` folder of your microSD card. 
- convert the .sav file in order to make it have the preferrable size. You can achieve this, for example, with [Save File Converter](https://savefileconverter.com/#/mister): pick the .sav files from your Anbernic as the input file on the left side (MiSTer), and choose "Game Boy Advance" as the platform. On the right side, pick 128kB as the size. By default, it will rename it to `.srm`, but you can simply rename the file to let it have the `.sav` extension and things will work out nicely. 

You can then try both the ROM and saved file with an emulator such as mGBA or by placing both files back on the Anbernic (again, making sure that the ROM and the `.sav` file have exactly the same name, and differ only for their extension), and everything should work: the first time you run it, it may say the the save file is corrupted and it is taking a previously saved version, but really, all is fine, and you can take it from here. If you still have issues, try to run the saved files through [other converters](https://savefileconverter.com/#/other-converters) and then again through the previously mentioned one. 

### Step 2: make sure you've done all the in-game requirements on both games

Easier said than done: this basically means that you must have finished both Fire Red and Emerald. In Fire Red, beat the Elite Four and bring both gems to Celio in One Island to fix the Network Machine (you'll find plenty of walkthroughs on-line to figure out the details, e.g. [this](https://www.ign.com/wikis/pokemon-firered-leafgreen-version) or [this](https://strategywiki.org/wiki/Pok%C3%A9mon_FireRed_and_LeafGreen/Walkthrough)). In Emerald, you need to get the National Pokedex after beating the Pokemon League ([walkthrough](https://bulbapedia.bulbagarden.net/wiki/Walkthrough:Pok%C3%A9mon_Emerald)). 

You should also make sure to have at least two Pokemons in your party.

Things are easier with Ruby and Sapphire, as you already start with a National Pokedex, so, unlike with Emerald, you can trade without finishing the game. Also in these cases, consider that the ROM that comes with at least some versions of the Anbernic are problematic: e.g. I couldn't even save locally on the Anbernic with the version of Pokemon Saphire it original came with; find [a more solid version on-line](https://visualboyadvance.org/gba-roms/pokemon-sapphire/).

### Step 3: move things back on your computer

When you've finished all the in-game requirements, take both ROMs and both `.sav` files from you Anbernic and copy them on your computer. In principle, you can do everything directly on the microSD card, but I'd suggest it's a good idea to make a backup copy before proceeding. 

Open the [mGBA](https://mgba.io/) emulator, load the Emerald ROM, then pick File -> New multiplayer window. In the new window, open the Fire Red ROM. With the mGBA version available at the time of this writing (0.10.5), it won't file the save file in this second window even if it is named the same as the ROM: just go File -> Save games -> Load alternate save game, and pick your `.sav` file. 

### Step 4: trade in game

Now you can proceed in game. If you're just used to play with your Anbernic, just keep in mind that by default in mGBA "X" is the A button, and "Z" the B button, and "Enter" is the start button. So within mGBA, in each of the two games, one after the other, go upstairs and talk to the person at the last counter on the right, and say you want to do trade. And just... go with it. It's similar to what you see [in this video](https://www.youtube.com/watch?v=q8ROqsmnMTg), just a different counter.

### Step 5: move things back to the Anbernic

If you're accustomed to play on the Anbernic, after you're finished with trading just save, exit, move your files back to the device (consider using a different filename for both ROM and `.sav` file, if you want to keep the previous version as well), and you should be good to.


