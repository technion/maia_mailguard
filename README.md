This repo is derived from the technion fork of Maia mailguard.

We are building on the updates from technion while holding off on certain changes e.g. scrypt, which we feel would be better suited to a version 1.1 release. Our goal is to obtain a stable, working install of the updated mailguard 1.0 branch, with a quick (for the common case) installation process.

The initial target platform will be Centos 7 on openvz, due to the ease and speed of deployment. The other primary distros (SuSE/SLES, Debian/Ubuntu) will also be tested and verified. Other hardware platforms (lxc containers, VMs and conventional machines) will be tested as well. Everything in it's order, as time and resources allow.

-- 

The README from the original technion fork is below:

The original license has been replaced with a GPL license with the blessing of the project's original creator. See license.txt for further information.

This fork brings the project in line with current deployments and technology, such as newer versions of PHP.

Some features are known to be untested and probably broken, such as authentication mechanisms other than "internal".

There are some new requirements on PHP modules, these are easiest identified by running the standard configtest.php.

I would greatly appreciate an updated installation guide for this fork, if anyone wanted to contribute.

