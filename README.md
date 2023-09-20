<div align="center">

# DDEV CMS Upgrader

**A sample script to automatically upgrade major CMS versions with DDEV and Bash (e.g. TYPO3,
Drupal, WordPress, Craft CMS)**

[![TYPO3 Usergroup Magdeburg](https://img.shields.io/badge/TYPO3-Usergroup_Magdeburg-ff8700?style=flat-square&logo=typo3)](https://www.meetup.com/de-DE/typo3-usergroup-magdeburg/)
[![DDEV](https://img.shields.io/badge/DDEV-Foundation-02a8e2?style=flat-square&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAACXBIWXMAAAsSAAALEgHS3X78AAABIElEQVQ4jY2T0XGDMBBE383wbzoIHYRUELuDdBBTQXAH7sAlQCdOKsCuIKQC6GDzkVOsgCDeGY3uxGnvMZKMFUn69LBfKLmY2SEk2ZoZcAFG4CvxbQPUknIzqwAsQVMAnRv91+gKNEBrZlWKbIzm64LRBqiBFqiARtKNTNIReFwxmDYcA5XvOcVkz0AJ5J4XPnr+HkDudS1wAE7ADiCT1HiXDx+hcwuc3TCsPzhFD+yDya+0rEZSLqmbrJ8lHT3exnMGPEWdRo9fPcd/Jajw+Y3bQc0laVihnGpwmi6KFZuVfseQtA/xQuN8YtRJGlKF2xnHfXRl6gXk/FzI8JS2wHsCMNyzAtiZ2fqLkVTfQVeG+hnZxKwEXiLKqXoz60PyDWDeV6d2QUBxAAAAAElFTkSuQmCC)](https://ddev.com/)

</div>

## ✨ The Idea

After a major version upgrade of a CMS, there are often plenty of manual steps to take, like
running Upgrade-Wizards, SQL Migrations, other Scripts, etc.

This script should help to automate these steps and make the upgrade process more efficient and
reproducible by using DDEV, branches of each major version, and Bash scripts. For each major version,
a DDEV environment will be started, the upgrade steps will be executed via DDEV's post-start hooks
and then stopped. Afterward, the next major version will be started and so on.

**This script is a sample that should be adjusted to your project's needs.**

_[ to be extended ]_

## 🔧 Preparations

- Create branches for each major version in a structure `CMS-MAJOR_VERSION`
    - (e.g. `typo3-10.4`, `typo3-11.5`, `typo3-12.4`)
- Add a MySQL dump of the current/the oldest production version to a git-ignored folder
    - This will be used to import the database in the first version cycle during the upgrade process

_[ to be extended ]__

## 🚀 Usage

1. Clone or download this repository into your project
2. Copy the `.env.sample` file to `.env` and adjust the variables
3. Adjust paths if needed in [`auto-upgrade.sh`](auto-upgrade.sh)
4. Run the script

## 📝 Example with TYPO3

_[ to be extended ]_

## 💎 Credits

This script was created within the [TYPO3 Usergroup Magdeburg](https://www.meetup.com/de-DE/typo3-usergroup-magdeburg/)
during a live coding session testing to automate the upgrade process of TYPO3 with DDEV and Bash.

Thanks to [Karsten Nowak](https://github.com/kanow) for the idea to test this approach!
