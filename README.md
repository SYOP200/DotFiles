## DotFiles
My config files for MacOS.

## How to set up
Before using these files, you may need to install and create Apple Shortcuts for everything to function properly. <br>
Use the commands below in your terminal (Iterm2)

```bash
#1. Clone the repo
git clone https://github.com/SYOP200/Dotfiles

#2. Enter the DIR 
cd ~/Dotfiles

#3. Save all of the files first (RECOMMENDED)
mkdir ~/Backups
cp ~/.config/nvim ~/Backups
cp ~/.config/btop ~/Backups
cp ~/.config/fish ~/Backups
cp ~/.config/iterm2 ~/Backups
cp ~/.config/yabai ~/Backups
cp ~/.config/sketchybar ~/Backups

#4. Delete files that will be replaced (copy these to a backup folder first!)
rm -rf ~/.config/nvim
rm -rf ~/.config/btop
rm -rf ~/.config/fish
rm -rf ~/.config/iterm2
rm -rf ~/.config/yabai
rm -rf ~/.config/sketchybar

#5. Move the files to their locations
mv nvim ~/.config/
mv sketchybar ~/.config/
mv yabai ~/.config/
mv iterm2 ~/.config/
mv fish ~/.config/
mv btop ~/.config/
mv startup ~/

```

## Contributing
If you want to contribute to this repo and share your thoughts, create a PR, issue, or a Discussion!

## Previews/screenshots:
Terminal:
<img width="1710" height="1112" alt="Screenshot 2026-03-24 at 18 28 01" src="https://github.com/user-attachments/assets/8e82fb41-337e-4ac9-82e2-690ecf143ce9" />

Neovim:
<img width="1710" height="1112" alt="Screenshot 2026-03-24 at 18 31 55" src="https://github.com/user-attachments/assets/885f3860-cc61-4db8-b43c-50cbdd72c9af" />

Desktop:
<img width="1710" height="1112" alt="Screenshot 2026-03-24 at 18 33 48" src="https://github.com/user-attachments/assets/ede65e1d-268a-4988-b1ed-6fe6df3ef6bd" />
