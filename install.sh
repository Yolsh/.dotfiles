cd $HOME/.dotfiles

cp ./installer/install.py /lib64/python3.13/site-packages/archinstall/scripts/

archinstall --script install --config ./installer/conf --creds ./installer/creds --dry-run
# remove the dry run later