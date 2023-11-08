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

## 📝 Example Upgrade with TYPO3

Preparation and requirements to update an existing TYPO3 website from version 9.5 to version 12.

* Existing local development system with DDEV and the current TYPO3 version 9.5
* latest database dump from the live system, ready for import in local system
* local system is not running

Before starting with creating new branches or adjust data in the .env file you have to decide whether you can
go directly to the last TYPO3 version or not.
That depends on your installation and used extension. Normally you need some upgrade wizards
to update the database step by step for the single TYPO3 version.

Let's assume you need an upgrade wizard of an extension that exists only in a version for TYPO3 10.
And another extension with an upgrade wizard in TYPO3 11. Then you need both of them 10 and 11 and
finally a branch for TYPO3 12.

If you don't need to execute upgrade wizards of extensions, or using the
[`Core-Upgrader`](https://github.com/WapplerSystems/core_upgrader) to execute all upgrade wizards
from previous TYPO3 versions, then you just need some code in the DDEV commands.
Of course it is possible to use our upgrade script also with just one target branch.

Now create a branch for the first needed TYPO3 version. We assume that we need upgrade wizards
from extension in TYPO3 10, 11 and 12.

---
> Always add only the respective version of the current branch in the .env file
> That means: if you start in branch 10.4, versions in .env file are only "10.4"
> If you create (or switch) to the next branch 11.5, versions in .env file should "10.4 11.5"
> In the next branch 12.4, version should be "10.4 11.5 12.4" and so on…
> That gives you the possibility to run the upgrade only up to the current branch.
---

We assume you are on the main branch of your website. Start with creating a new branch `typo3-10.4`.
Add version 10.4 to the .env file
This is the first branch where we need our DDEV Post-Start Hooks. Add your DDEV Post-Start Hooks.

**We have some DDEV's post-start hook commands example here**

```yaml
    hooks:
      post-start:
        - exec: ../.ddev/commands/web/composerinstall
        - exec: ../.ddev/commands/web/warmup
        - exec: ../.ddev/commands/web/upgrade-steps-10.4
```

Move them to your `.ddev` folder and adjust the code to your needs.
You can add more files and hooks if you need some. Maybe there are some steps needed to delete
folders and files in your installation. There is a sample file  [`aftercheckout`](.ddev/commands/web/aftercheckout)
for doing stuff locally after checkout the branch.

---
> We recommend that you perform as many database actions as possible in the upgrade steps.
> Sometimes it's easy to save the data in the backend after doing changes and make a simple sql
> export for generating the update query. Then use this in individually sql files.
---

There is an example to execute your own sql on upgrade step in the file
[`UpdateQueryForMe.sql`](.ddev/commands/web/UpdateQueryForMe.sql).

#### Import database on the first branch

There is a special feature in the first branch. You have to import the database. For those step
we have a ddev post-start hook for that. Our sample file expect sql (or sql.gz) file in the folder

    fixtures/database

Be sure there is a file and database is empty.

In the following branches, you can remove that hook from the config.yaml

Thats it!

---

Commit your changes and go further to create the next branch. Add the next version to the .env file,
add news files and commands for ddev's post-start hooks. Commit your changes

We are using separate files for each TYPO3 version and adding a new one in each branch and changing
the post-start hook command. It's also possible to use one file without a version dependency.
Then you just have to change the code inside the file for each branch (version).

---

If you finished creating all branches and the post-start hooks for DDEV it is time to test your upgrade.

#### Start your automatically upgrade

You have to prepare something to start the upgrade process. We assume you are in the latest branch.
In our example this is the branch `typo3-12.4`.

* Stop the running DDEV containers
```
ddev stop
```
* delete the DDEV containers. Upgrade should start everytime with a clean database. It's possible to create a backup before doing this step.
```
ddev delete -O
```
* now start the upgrade script `./auto-upgrade.sh`

---
> I always want to know how long such an upgrade will run, therefore I use the `time` command.
> starting upgrade with `time ./auto-upgrade.sh`
---

I hope that works for you. And now … happy upgrading 😄

## 💎 Credits

This script was created within the [TYPO3 Usergroup Magdeburg](https://www.meetup.com/de-DE/typo3-usergroup-magdeburg/)
during a live coding session testing to automate the upgrade process of TYPO3 with DDEV and Bash.

Thanks to [Karsten Nowak](https://github.com/kanow) for the idea to test this approach!
