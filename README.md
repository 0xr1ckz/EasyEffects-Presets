# EasyEffects HRIR Presets (Atmos-like, headphones)

Output-chain presets for [EasyEffects](https://github.com/wwmm/easyeffects) that add per-ear (HRIR/BRIR) convolution, a tuned EQ, bass harmonics and a limiter.

"Atmos-like" means binaural spatialization of a stereo stream through measured impulse responses.

**In plain words:** on normal stereo headphones, music, movies and games usually sound like they come from inside your head. These presets aim to make them sound like they come from speakers placed around you.

## Quick start

1. **You need:** Linux with PipeWire, [EasyEffects](https://github.com/wwmm/easyeffects) installed, and headphones. Speakers cancel the effect.
2. **Get the files:** on this page click the green **Code** button, then **Download ZIP**, and unzip it. (Or use `git clone`.)
3. **Install the presets:** open a terminal inside the unzipped folder and run:
    
    ```sh
    chmod +x install_all.sh
    ./install_all.sh
    ```
    
    Installed EasyEffects as a Flatpak? Run `FLATPAK=1 ./install_all.sh` instead. To check, run `flatpak list | grep -i easyeffects`. If it prints a line, you use the Flatpak.
4. **Turn one on:** open EasyEffects, open the Presets menu, and click a preset under **Output**. Or run `easyeffects -l atmos-v3-cinema`.

## Which preset should I pick?

|If you want|Try|
|---|---|
|Music, a safe first choice|`Atmos_lite_v2_hrir`|
|Movies and shows, clearer dialogue|`atmos-v3-cinema`|
|Games, clearer sound positions|`atmos-v3-gaming`|
|Low volume or late night, less bass|`atmos-v3-night`|
|Headphones that already have strong bass|`atmos-neutral-ku100`|

## What it does

Your sound passes through these steps, in this order:

```
stereo in -> convolver (true-stereo BRIR) -> [stereo_tools, bypassed] -> [reverb, bypassed]
          -> bass_enhancer -> equalizer -> limiter -> out
```

(`stereo_tools` and `reverb` are switched off in the v2, v3 and neutral presets.)

- **Convolver:** a 4-channel impulse response. Each input channel is filtered for both ears (L->L, L->R, R->L, R->R). The cross-ear paths carry the externalization cue. A plain stereo IR lacks them. _Plain words: this is the main trick. It copies how sound from a speaker reaches each of your ears, including the small delay and the muffling around your head._
- **Equalizer:** a fixed correction and tone curve (see "Presets"). _Plain words: turns some pitches (bass, treble) up or down._
- **Bass enhancer:** adds harmonics below 150 Hz so bass reads as larger on drivers that roll off. _Plain words: makes bass feel bigger on small headphone drivers._
- **Limiter:** catches clipping from EQ boost and harmonics. _Plain words: stops loud peaks from distorting._

## Presets

|Preset|IR|EQ bands|EQ pre-gain|Enhancer|Limiter|Intended use|
|---|---|---|---|---|---|---|
|`Atmos_lite_v2_hrir`|ash_ku100_ts|10|-3.0 dB|amount 5|-1 dBFS|music, baseline|
|`atmos-v3-cinema`|ash_spirit_ts|20|-4.5 dB|amount 5|-1 dBFS|movies, dialogue|
|`atmos-v3-gaming`|ash_kemarn_ts|19|-4.0 dB|amount 5|-1 dBFS|positional audio|
|`atmos-v3-night`|ash_ku100_ts|14|-3.0 dB|amount 2|-3 dBFS|low volume, reduced bass|
|`atmos-neutral-ku100`|ash_ku100_ts|12|-1.5 dB|off|-1 dBFS|neutral headphones|

- v3 presets keep the v2 EQ bands unchanged and append bands for (a) the difference between IRs and (b) the use-case change.
- `atmos-neutral-ku100` targets a flat net response (IR coloration cancelled, partial above 3.2 kHz). The others do not.
- `night` does not compress. It only cuts bass, lifts intelligibility and lowers the limiter threshold.

Older presets, kept for comparison. They have no convolver, so they only widen the sound and add reverb:

- `3d_spital`: the first, simple preset (stereo widening and reverb).
- `Atmos_lite_v1`: widening, reverb, EQ and limiter.

## Folder layout

```
README.md
install_all.sh
3d_spital.json            older preset
Atmos_lite_v1.json        older preset
Atmos_lite_v2_hrir.json   music, baseline
irs/                      the impulse responses (.irs) + irs.md
v3/                       the four newer presets (.json) + version_3.md
```

More detail on each folder: `irs/irs.md` and `v3/version_3.md`.

## Install

```sh
./install_all.sh              # native
FLATPAK=1 ./install_all.sh    # Flatpak
easyeffects -l atmos-v3-cinema
```

This copies `irs/*.irs` to the EasyEffects `irs` directory and `*.json` to the `output` presets directory.

_Plain words: the script puts the impulse responses and the preset files where EasyEffects looks for them. Run it from the main folder of this repo. Restart EasyEffects if a preset does not show up._

## Measured IR data

Measured offline from the shipped 4-channel files (left ear, 48 kHz).

|IR|D/R|C50|T20|Character|
|---|---|---|---|---|
|ash_kemarn_ts|+8.1 dB|+21.7 dB|0.19 s|driest, clearest|
|ash_ku100_ts|+6.5 dB|+19.7 dB|0.22 s|middle|
|ash_spirit_ts|+5.4 dB|+13.7 dB|0.32 s|most room|

- D/R: direct sound (first 2.5 ms after onset) vs the rest. C50: first 50 ms vs the rest. T20: from a Schroeder decay.
- All three IRs read about +5 dB at 63 Hz and -2.5 to -6 dB at 6.3 to 8 kHz relative to the 0.5 to 2 kHz mean.
- The v2 EQ on the KU100 IR nets about +10 dB at 63 Hz and +6 dB at 4 kHz relative to the midrange (estimate from biquad model).

_How to read the table: D/R is how much of the sound is direct compared with echo (higher = less echo). C50 is clarity (higher = clearer). T20 is how many seconds the echo takes to fade (lower = less room sound). "Room" here means the virtual room the IR was recorded in._

## How the IRs were built

_Advanced section. You can skip it. The presets work without reading it._

Source: ASH Listening Set, HeSuVi-format 14-channel HRIRs. Channel order in those files: `FL-L, FL-R, SL-L, SL-R, RL-L, RL-R, FC-L, FR-R, FR-L, SR-R, SR-L, RR-R, RR-L, FC-R` (index 0..13). Verified by checking onset and energy on the front pairs: the near ear arrives about 10 to 12 samples earlier and louder.

EasyEffects reads a 4-channel kernel as `[L->L, L->R, R->L, R->R]`, so the repack is:

```python
k = np.stack([d[:,0], d[:,1], d[:,8], d[:,7]], axis=1)   # FL-L, FL-R, FR-L, FR-R
sf.write("out.wav", k.astype("float32"), sr, subtype="FLOAT")   # rename to .irs
```

Only the front-left and front-right virtual speakers (around +/-30 degrees) are used. There are no rear or elevation cues. Games that output 7.1 need a surround-aware path such as a PipeWire virtual-surround filter-chain.

## Tested

- Tested by ear on three headphones, against the headphone's own EQ. This is subjective and a sample of three, not a claim for every headphone.
- EQ curves are fitted to the measured IR response; the fit error is about 1 to 2 dB.
- EasyEffects version tested: `<fill in>`.

## Limits

- Fixed EQ. A headphone's own response is not measured or corrected. A per-headphone correction (for example an AutoEq profile) can be added as an extra EQ stage.
- HRIRs are not personalized. Externalization varies per listener. Try the three IRs.
- Stereo input only. No head tracking, no object rendering.

## Words you will see

- **EasyEffects:** a Linux app that processes all your sound (equalizer, effects) before it reaches your headphones.
- **Preset:** a saved set of EasyEffects settings. One file, one click.
- **EQ (equalizer):** volume controls for different pitches, from deep bass to high treble.
- **Impulse response (IR):** a recording of how a sound changes on its way from a speaker to your ear. Applying it to music copies that effect.
- **HRIR / BRIR:** an impulse response measured with a head model (HRIR), or a head model in a room (BRIR). It is what makes headphones sound like speakers around you.
- **Convolver:** the EasyEffects part that applies an impulse response to your sound.
- **Limiter:** a safety stop that keeps peaks from distorting.
- **dB:** decibels, a unit of loudness change. +3 dB is clearly louder, -3 dB is clearly quieter.

## If something goes wrong

- **Preset not in the list:** run `./install_all.sh` from the main folder of this repo, then restart EasyEffects.
- **No change in the sound:** make sure the preset is loaded under **Output** and the Convolver is switched on with an impulse response selected.
- **Too loud, quiet or distorted:** lower your system volume first, then try `atmos-v3-night` or `atmos-neutral-ku100`.
- **Sounds odd on speakers:** these presets are made for headphones only.

## Credits and license

- Impulse responses derived from the **ASH Listening Set** by Shanon Pearce, licensed **CC BY-NC-SA 4.0**. The derived `.irs` files carry the same license (attribution, non-commercial, share-alike).
