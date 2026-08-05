# godot-synths

Godot project that uses [godot-csound](https://github.com/nonameentername/godot-csound/) and [godot-distrho](https://github.com/nonameentername/godot-distrho/) to build a synthesizer.

Currently works with Godot v4.7 stable release.

GodotSyth running in the browser [godot-synths](https://nonameentername.github.io/godot-synths/godot-synths.html)

![godot-synths](https://github.com/nonameentername/godot-synths/blob/main/godot-synths.png)

Currently works with **Godot 4.7 stable**.

## Build

### 1. Install the dependencies

Run the following command from the project directory:

```bash
godot --headless -s package.gd install
```

### 2. Import the Godot resources

```bash
godot --headless --import
```

### 3. Open the project

```bash
godot --editor project.godot
```

## Export the Plugin

Export the Linux LV2 audio plugin:

```bash
godot --headless --export-debug "LinuxLV2"
```

Export the Linux VST3 audio plugin:

```bash
godot --headless --export-debug "LinuxVST3"
```

## Install the Plugin

Copy the Linux LV2 plugin to your local LV2 directory:

```bash
mkdir -p ~/.lv2
cp -r build/linux/godot-synths.lv2 ~/.lv2/
```

Copy the Linux VST3 plugin to your local VST3 directory:

```bash
mkdir -p ~/.vst3
cp -r build/linux/godot-synths.vst3 ~/.vst3/
```
