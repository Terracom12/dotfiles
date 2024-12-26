# Dotfiles

:wave: My dotfiles for use with Linux (primarily Ubuntu right now, but planning on configuring arch soon<sup>TM</sup>).


Uses [chezmoi](https://www.chezmoi.io/) for dotfile management. Planning to add [ansible](https://docs.ansible.com/ansible/latest/index.html) soon for package management.


Install these dotfiles on a newly created system with the following command (Prerequisite: ssh auth to GitHub must be set up):
```shell
export GITHUB_USERNAME=Terracom12
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --ssh $GITHUB_USERNAME
```
