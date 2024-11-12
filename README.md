<div align="center">

# DDEV CMS Upgrader

**A sample script to automatically upgrade major CMS versions with DDEV and Bash (e.g. TYPO3,
Drupal, WordPress, Craft CMS)**

[![TYPO3 Usergroup Magdeburg](https://img.shields.io/badge/TYPO3-Usergroup_Magdeburg-ff8700?style=flat-square&logo=typo3)](https://www.meetup.com/de-DE/typo3-usergroup-magdeburg/)
[![DDEV](https://img.shields.io/badge/DDEV-Foundation-02a8e2?style=flat-square&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAACXBIWXMAAAsSAAALEgHS3X78AAABIElEQVQ4jY2T0XGDMBBE383wbzoIHYRUELuDdBBTQXAH7sAlQCdOKsCuIKQC6GDzkVOsgCDeGY3uxGnvMZKMFUn69LBfKLmY2SEk2ZoZcAFG4CvxbQPUknIzqwAsQVMAnRv91+gKNEBrZlWKbIzm64LRBqiBFqiARtKNTNIReFwxmDYcA5XvOcVkz0AJ5J4XPnr+HkDudS1wAE7ADiCT1HiXDx+hcwuc3TCsPzhFD+yDya+0rEZSLqmbrJ8lHT3exnMGPEWdRo9fPcd/Jajw+Y3bQc0laVihnGpwmi6KFZuVfseQtA/xQuN8YtRJGlKF2xnHfXRl6gXk/FzI8JS2wHsCMNyzAtiZ2fqLkVTfQVeG+hnZxKwEXiLKqXoz60PyDWDeV6d2QUBxAAAAAElFTkSuQmCC)](https://ddev.com/)
[![TYPO3 News Article](https://img.shields.io/badge/TYPO3-News_Article-ff8700?style=flat-square&logo=typo3)](https://typo3.org/article/automatic-typo3-updates-across-several-major-versions-with-ddev)

</div>

## ✨ The Idea

After a major version upgrade of a CMS, there are often plenty of manual steps to take, like
running Upgrade-Wizards, SQL Migrations, other Scripts, etc.

This script should help to automate these steps and make the upgrade process more efficient and
reproducible by using DDEV, branches of each major version, and Bash scripts. For each major version,
a DDEV environment will be started, and the upgrade steps will be executed via DDEV's post-start
hooks and then stopped. Afterward, the next major version will be started, and so on.

Read more about in the [TYPO3 News Article](https://typo3.org/article/automatic-typo3-updates-across-several-major-versions-with-ddev).

**This script is a sample that should be adjusted to your project's needs.**

## 🔧 Preparations

- Create branches for each major version in a structure `CMS-MAJOR_VERSION`
    - (e.g. `typo3-10.4`, `typo3-11.5`, `typo3-12.4`)
- Add a MySQL dump of the current/the oldest production version to a git-ignored folder
    - This will be used to import the database in the first version cycle during the upgrade process

## 🚀 Usage

1. Clone or download this repository into your project
2. Copy the `.env.sample` file to `.env` and adjust the variables
3. Adjust paths if needed in [`auto-upgrade.sh`](auto-upgrade.sh)
4. Run the script

## 📝 Example Upgrade with TYPO3

Preparation and requirements to update an existing TYPO3 website from version 9.5 to version 12.

* Existing local development system with DDEV and the current TYPO3 version 9.5
* Latest database dump from the live system, ready for import into the local system
* local system is not running

Before starting with creating new branches or adjusting data in the .env file, you have to decide
whether you can go directly to the last TYPO3 version or not. That depends on your installation and
used extensions. Usually, you need some upgrade wizards to update the database step-by-step for the
single TYPO3 version.

Let's assume you require an upgrade wizard for an extension that exists only in a version of TYPO3 10.
And another extension with an upgrade wizard in TYPO3 11. Then you require both of them, 10 and 11,
and finally a branch for TYPO3 12.

If you don't need to execute upgrade wizards of extensions, or use the
[`Core-Upgrader`](https://github.com/WapplerSystems/core_upgrader) to execute all upgrade wizards from previous TYPO3 versions, then you just
need some code in the DDEV commands. Of course, it is possible to use our upgrade script with
just one target branch.

Now create a branch for the first needed TYPO3 version. We assume that we require upgrade wizards
from extensions in TYPO3 10, 11 and 12.

---
> Always add only the respective version of the current branch in the .env file
> That means: if you start in branch 10.4, versions in .env file are only "10.4"
> If you create (or switch) to the next branch 11.5, versions in .env file should "10.4 11.5"
> In the next branch 12.4, version should be "10.4 11.5 12.4" and so on …
> That gives you the possibility of running the upgrade only up to the current branch.
---

We assume you are on the main branch of your website. Start with creating a new branch `typo3-10.4`.
Add version 10.4 to the .env file. This is the first branch where we need our DDEV Post-Start Hooks.
Add your DDEV Post-Start Hooks.

**We have some examples of DDEV's post-start hook commands here:**

```yaml
hooks:
  post-start:
    - exec-host: ddev composerinstall
    - exec-host: ddev warmup
    - exec-host: ddev upgrade-steps-10.4
```

Move them to your `.ddev` folder and adjust the code to your needs. You can add more files and hooks
if you need them. Maybe there are some steps needed to delete folders and files in your installation.
There is a sample file  [`aftercheckout`](.ddev/commands/web/aftercheckout) for doing stuff locally after checkout the branch.

---
> We recommend that you perform as many database actions as possible in the upgrade steps.
> Sometimes it's easy to save the data in the backend after doing changes and make a simple sql
> export for generating the update query. Then use this in individually SQL files.
---

There is an example of how to execute your SQL on the upgrade step in the file
[`UpdateQueryForMe.sql`](.ddev/commands/web/UpdateQueryForMe.sql).

### Import the database on the first branch

There is a special feature in the first branch. You have to import the database. For those step,
we have a ddev post-start hook for that. Our sample file expects a .sql (or zipped as .sql.gz) file
in the folder

    fixtures/database

Be sure there is a file and the database is empty.

In the following branches, you can remove that hook from the config.yaml

That's it!

---

Commit your changes and go further to create the next branch. Add the next version to the .env file,
add new files and commands for ddev's post-start hooks. Commit your changes.

We are using separate files for each TYPO3 version, adding a new one to each branch, and changing
the post-start hook command. It's also possible to use one file without a version dependency. Then
you just have to change the code inside the file for each branch (version).

---

If you have finished creating all branches and the post-start hooks for DDEV it is time to test
your upgrade.

### Start your automatically upgrade

You have to prepare something to start the upgrade process. We assume you are in the latest branch.
In our example, this is the branch `typo3-12.4`.

* Stop the running DDEV containers
```
ddev stop
```
* delete the DDEV containers. Upgrades should start everytime with a clean database. It's possible
to create a backup before doing this step.
```
ddev delete -O
```
* now start the upgrade script `./auto-upgrade.sh`

---
> I always want to know how long such an upgrade will run, therefore I use the `time` command.
> Starting upgrade with `time ./auto-upgrade.sh`
---

I hope that works for you. And now … happy upgrading 😄

## 🚀 Possible improvements

This tool is just a first approach, an idea, a suggestion. It is certainly appropriate to
improve it.

### One possible variant with stop using DDEV's post-start hooks.

A check for the first run was added in the `auto-upgrade.sh`. Now it's possible to do some special
things on first run:

* Use ddev providers to get a database dump from production and import them automatically
  * Not implemented here. That depends on your production system. You have to do it by yourself.
See DDEV Docs: https://ddev.readthedocs.io/en/stable/users/providers/
* Do some preparation stuff (composer install, activate extensions, updateschema …)
  * See example for `.ddev/commands/web/warmup`
* Do upgrade steps with the command in DDEV's Web-Container (`.ddev/commands/web/upgrade`).
  * File/DDEV-Command (`upgrade-steps-10.4` -> `upgrade`) renamed. It's enough to change code in the
file for each branch. Filename is secondary.


## 💎 Credits

This script was created within the [TYPO3 Usergroup Magdeburg](https://www.meetup.com/de-DE/typo3-usergroup-magdeburg/)
during a live coding session testing to automate the upgrade process of TYPO3 with DDEV and Bash.

Thanks to [Karsten Nowak](https://github.com/kanow) for the idea to test this approach!
