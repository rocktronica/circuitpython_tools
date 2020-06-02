# circuitpython_tools

```
➜ cpt -h
Collection of tools to make working with CircuitPython boards easier.

Usage:
circuitpython_tools.sh -h       # show this message
circuitpython_tools.sh open     # open USB device in Finder
circuitpython_tools.sh build    # make _build folder, ready for deployment
circuitpython_tools.sh deploy   # actually deploy ^ to device
circuitpython_tools.sh watch    # watch for changes to automatically build and deploy
circuitpython_tools.sh serial   # connect to device's serial console
circuitpython_tools.sh eject    # eject/unmount USB drive so it can be unplugged

To get smaller build files, install mpy-cross and expose it to cpt:
export CPT_MPY_CROSS="/path/to/mpy-cross"
```

This is a work-in-progress and much of it is OSX-specific.

## Installation

Download with git:

```bash
cd ~
git clone git@github.com:rocktronica/circuitpython_tools.git
```

And then expose it in your bash profile.

``` bash
alias cpt="~/circuitpython_tools/circuitpython_tools.sh"
```

### mpy-cross

cpt is meant to be used in tandem with `mpy-cross`, a compiler that converts Python's `.py` files into much smaller `.mpy` files. For that, follow [Adafruit's installation instructions](https://learn.adafruit.com/building-circuitpython/build-circuitpython) and then export it as `CPT_MPY_CROSS` alongside the `cpt alias` from above.

Mine looks like this, but yours may differ based on where you've installed stuff:

``` bash
export CPT_MPY_CROSS="~/circuitpython/mpy-cross/mpy-cross"
alias cpt="~/circuitpython_tools/circuitpython_tools.sh"
```

If cpt can't find `CPT_MPY_CROSS`, it skips compilation and simply copies your original `.py` files over.

## Usage

Use the `cpt` alias in the same folder where you keep your `main.py` and `lib` folder.

```bash
cd ~/my-cool-project

cpt watch
```

cpt will watch for any changes you make locally to your Python files and automatically compile and deploy them to the device.

## TODO

* work with both `code.py` and `main.py`
* expose rsync's dry-run or some way to confirm deployment changes w/o actually affecting device

## License

MIT License

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
