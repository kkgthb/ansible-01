# Ansible demo

---

## WARNING:  try Terraform first

If you want to provision/deprovision an infrastructure resource, do that with **Terraform**.

Please go as far as you reasonably can with Terraform before you start mucking about with Ansible.

However, if that resource just so happens to be a virtual machine, then once it's up and running, you might need to do something like install software onto it that turns it into a web server.  Do that with **Ansible**.

* _(**Tip:  First, though, think about whether a cloud service could just take care of turning a machine into a web server for you.  e.g. Azure App Service, AWS Elastic Beanstalk, Google Cloud Run, etc.)_

---

## Update:  code that may no longer match this readme but is my latest as of 2025-06-12

```powershell
Push-Location -Path './ansible_demo_01'
ansible-playbook './playbooks/main.yml'
Pop-Location
```

---

## Example Ansible use cases

* fetch values out of a system like Azure Key Vault or AWS Secrets Manager and saving them into the VM's operating system environment variables
* install Java onto the VM
* manage the Java JVM's parameters, thread pools, garbage collection settings, etc.
* tweak OS settings to open/close network ports
* tweak OS settings to add/remove/update cryptographic certificates
* add a user to the operating system's users list
* grant/revoke privileges for that user within the operating system
* tweak other OS kernel parameters & settings
* install/update/uninstall OS drivers for the hardware the VM is running on
* mount/dismount an external file store to the OS as an OS filesystem drive

---

## Example antipatterns (maybe don't use Ansible)

Once your VM has already been provisioned with Terraform and turned into a proper web server using Ansible, you're probably done.

You probably don't need Ansible to deploy your application, its feature-updates, and its fix-updates onto it.

Instead, you'll probably do that each time you commit fresh source code to Git version control, using a CI/CD pipeline platform like **GitHub Actions**, **Azure Pipelines**, etc.

_(For example, if your web server is simply looking at a mounted network fileshare for your "built" application executable, you can probably just have your CI/CD pipeline write to that fileshare and have your CI/CD pipeline ask the server to restart itself.)_

---

## Why not plain old shell scripts?

You definitely _could_ turn a brand new VM into a web server by making sure its filesystem contains a script file you wrote, SSHing into the VM, and running that file.

However, if you refactor that script to be Ansible-compatible, then Ansible will take care of some performance-enhancing niceties for you -- e.g. not bothering to try to create operating system user "`abc_xyz`" if it already exists and is already configured correctly.  That is, it saves you from having to write a bunch of "if-then-else" statements if you want your automations to behave in a "lazy" fashion.  Or e.g. picking up where you left off if the automation fails halfway through.

Furthermore, a lot of web server vendors write their "just run this to install our software" scripts in Ansible syntax.  If you can't beat 'em, join 'em.

---

## Will it do all configuration in one fell swoop?

Maybe -- if it can actually be done that way.

Although if part of your new-VM-config process involves clicking buttons in a vendor's installer wizard, you might have to break your Ansible automations up into two passes -- the "before clicky-parts" half and the "after clicky-parts" half.  Etc.

---

## Getting started

### Ansible as regression testing

One way to dip a toe into the water with Ansible, without committing to doing everything with it, is to author Ansible Playbooks that don't do any "write" actions -- just "read" actions that report out whether your VM is configured the way you expect it to be _(using Ansible's `assert` statement syntax)_.

* **Tip:**  Try getting comfortable with Ansible as a way of writing "regression tests" for your existing VM configuration changes before you worry about learning to use it as a way to _make_ those changes.

That way, you'll already be comfortably following the tried-and-true best practice of [test-driven development](https://en.wikipedia.org/wiki/Test-driven_development) when you finally start letting Ansible configure your VM.

#### Start with bug-fix tests

Overwhelmed by the idea of figuring out where to start when writing some regression tests for your VMs?

Think of the last time you had to fix a bug by SSHing into the VM _(or changing its settings with a graphical user interface that you could've changed at the VM's command line)_.

How did you verify that the change had really "saved"?

Was it an important enough change that you went back and updated your team's documentation about the "right" way to have that VM configured?

Pick an "important" one that _would_ be easy to verify from, say, the VM's OS's CLI, and start there.

Write and run an Ansible script that SSHes into the VM, validates that the setting is the way it's "supposed to" be, and reports the results of that test _("`assert`")_ back out to you.

#### Ansible is not the only regression testing tool

FWIW, Ansible won't be the _only_ tool in which you'll write automated tests.  It's just the tool with which you'll write inside-the-VM tests:

1. If the test can run _inside_ your VM's OS, Ansible is probably a great approach.
    * Example:  making sure that a Linux VM has user `abc_xyz` and that isn't an owner of the `pizza` folder on the VM's filesystem, and that the `pizza` folder is of access code `644` _(read-write for its owners; read-only for others)_.
    * Tip:  manually change the `pizza` folder's permissions to `600` _(non-owners have no access)_, and make sure your test that it's `644` fails.  If it doesn't, you wrote your Ansible "`assert`" test wrong.  Try again, make sure the test for `644` fails, and then flip permissions back from `600` to `644` and run the test again and make sure it passes.
1. If the test needs to run from _outside_ your VM's OS, you're probably better off just picking a testing framework that goes nicely with a programming language already installed onto the computer from which you'll be running your test _(e.g. PowerShell's "Pester" if you're running the tests from a Windows machine)_.
    * Example:  actually trying to SSH into the Linux VM using user `abc_xyz`'s password and validating that you can read files in the `pizza` folder but can't successfully `write` any.
    * Tip:  manually change the `pizza` folder's permissions to `600` and make sure you can't even _read_ files in the pizza folder.  If that test passes, you wrote your _(e.g. PowerShell/Pester)_ test wrong.  Fix it so it fails, then flip settings back to `644` and re-run it and make sure it succeeds.

### Ansible as configurator

Once you're comfortable writing the Ansible "`assert`" tests to validate that `abc_xyz` doesn't own `pizza` and that `pizza` is `644`, it's time to level up.

It's time to enhance your Ansible playbook by adding code to it that _**sets**_ `pizza` to `644` if it isn't.

When you think you've gotten it right, run your Ansible playbook against your VM with the `--check` flag, so it doesn't actually do anything, but thinks through what it _would_ do if you hadn't included that flag.  It should run your `assert`s you wrote earlier and report out the results.

The results should always _pass_ every time you run it in `--check` mode, no matter what the permissions setting on `pizza` is when you run it _(e.g. `600`, `644`, etc.)_ because, in theory, your new Ansible code _sets_ the value to 644.  _(And Ansible's `assert` validates against the hypothetical configuration it _would_ have done against your VM, not its real current state.  Hence why it should always pass.)_

Play around with manually flipping `pizza` to `600`, `644`, etc. and re-running your Ansible playbook in `--check` mode several times.  Does it always pass?  Hooray -- you probably wrote your new Ansible code correctly!

Give it a try running it without the `--check` flag.  Then:

1. Confirm:  did the Ansible `assert` statement regression tests all pass?
1. Confirm:  if you SSH into the VM, is `pizza` at `644`, even if you had it at `600` before you ran Ansible?
1. Confirm:  do your external regression tests all pass?  _(can `abc_xyz` actually SSH in and read but not write files in `pizza`)_?

If the answer to all 3 of these questions is "yes" pat yourself on the back!

You just wrote your very first VM "configuration management" automation in Ansible.  And you did it without risking quality, because you made sure to write a thorough suite of unit tests!

Maybe next, you'd like to play with manually deleting user `abc_xyz` and using Ansible to set it up.  _(And enjoy watching Ansible merely skip over user creation whenever `abc_xyz` already exists.)_

Don't forget to write and debug your unit tests _first_, before you write Ansible code that _does_ anything.  You won't be sorry!

### Running Ansible from CI/CD

That was fun, right?  Running Ansible against your VM from your work laptop?

Now it's time to think about teamwork.

Take a look at this repo to see an example of Ansible code that's stored in a "Git"-based source code version control system _(in this case, "GitHub Repositories")_.

TODO:  add source code

* _(Booooo, hiss.  [I can't run the Ansible CLI from a Windows machine](https://docs.ansible.com/ansible/latest/os_guide/intro_windows.html#using-windows-as-the-control-node).)_

Ideally, one day, you and your colleagues won't even need to be able to personally SSH into your VM or personally run Ansible against it.  But for now, let's just make sure that GitHub _also_ can do so.

TODO:  instructions

Run your new CI/CD pipeline over and over a few times, playing with manually flipping your `pizza` permissions around amongst `600`, `644`, etc., playing with having `abc_xyz` present or not present, etc.

According to the CI/CD logs, does Ansible do its job from the CI/CD pipeline just as well as it did from your laptop?  How about according to SSHing into your VM and validating the configuration yourself?  How about according to your external regression tests _(e.g. the Powershell/Pester ones)_ as run from your laptop?

Hooray!  Now let's talk about _also_ running those external regression tests from the CI/CD pipeline, for _extra_ confidence that your Ansible playbook is behaving as expected each time you run the CI/CD pipeline.

### Running your external regression tests from CI/CD

TODO; be sure to clarify that config authN & authZ are different from external-test authN & authZ!  And that, realistically, if you don't want to leave that many authNs lying around, you might want to axe those tests from your regression tests.  Or version-control those regression tests, but only run them from your laptop with interactive prompts.  _(Although if you store the credentials to all those accounts in, say, Azure Key Vault or AWS Secrets Manager, you should be able to do things from CI/CD just fine, if you want.  But then again, maybe you don't want the configurator identity being able to read that stuff out of Key Vault / Secrets Manager, and prefer pulling from Key Vault / Secrets Manager yourself and running on your laptop.  Lots of considerations, once we move into the real world, compared to "hello world"!)_

---

## Quick-testing an Ansible installation

Update, 2/4/26:  I successfully used this repository to validate that Ansible is actually installed into the ephemeral Linux boxes that Azure subscribers have access to whenever they poke around the "Azure Cloud Shell":

1.	Execution:
    * `cd ~`
    * `git clone https://github.com/kkgthb/ansible-01.git`
    * Choose, depending whether you prefer PowerShell or Bash:
        * PowerShell:
            * `& ~/ansible-01/.cicd_pipeline_helpers/i_only_run_on_posix_not_windows.ps1`
        * Bash:
            * `chmod +x ~/ansible-01/.cicd_pipeline_helpers/i_only_run_on_posix_using_bash.sh`
            * `~/ansible-01/.cicd_pipeline_helpers/i_only_run_on_posix_using_bash.sh`
2.	Validation:
    * `ls -la ~/ansible_play/files_go_here`
        * _(Yes, `helloworld.txt` file shows up)_
    * `ls -la ~/ansible-01/ansible_demo_01/test-results/junit-results`
        * _(Yes, some `*.xml` files show up)_

---

## Related blog posts

* [Why use Ansible for infrastructure as code?](https://katiekodes.com/why-ansible/)
* [How to test if Ansible is installed](https://katiekodes.com/is-ansible-installed/)