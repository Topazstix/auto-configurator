# Auto-Configurator
I've used a few specific configurations for linux shells for awhile, and they have been the reason (or at least a good factor) for my productivity. This script is something I've been meaning to write for awhile, and I finally got around to it. It's a simple script that will install and configure a few things for you. Currently this ***ONLY WORKS IN UBUNTU.*** It's not perfect, but it's a start. Once I get a few more things configured, I'll add them to the script. If you have any suggestions, feel free to let me know.


#### TODO: 
* Add tmux confs
* Add nvim confs
* Make OS agnostic
* ???

---

## Installation
Clone the repository and then run the script!
```bash
git clone https://github.com/Topazstix/auto-configurator.git
cd auto-configurator
chmod +x ./zsh_super_confs.sh
sudo ./zsh_super_confs.sh
```

## What it does
The script (currently) does the following:
* Updates apt repos
* Installs:
    * zsh
    * zsh-syntax-highlighting
    * zsh-autosuggestions
    * [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
    * [powerlevel10k zsh theme](https://github.com/romkatv/powerlevel10k)
* Copy configs to their necessary locations
* Change default shell to zsh

> I would *HIGHLY* encourage you to check out and read through oh-my-zsh and the powerlevel10k repos. They have a lot of great information and documentation on how to use them. Specifically powerlevel10k, which requires a specific type of font to be installed in order to get the cool icons. Their docs cover installing nerd fonts and how to set them up.

<!-- ## What it looks like
Insert images of the program? Maybe? -->

## Issues
* Currently only works in Ubuntu
* When the script exits, it will leave you in a root prompt. Just type `exit` and you'll be back to your normal user
    * This will be fixed in the future
* ??? If you find any, let me know!

## Credits
* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* [powerlevel10k zsh theme](https://github.com/romkatv/powerlevel10k)
* Saucy (for tmux and nvim confs)
* Shout out to my classmate for getting me to start the thing in the first place lol

