This is a fork of the technion fork of Maia mailguard.

This fork seeks to build on the updates from technion while backing out problematic changes such as scrypt. The goal is to get a working install of mailguard for the Centos 7 reference platform, and provide an optimized, documented installation process for creating an openzv container-based mailguard server.

The README from the original technion fork is below:

The original license has been replaced with a GPL license with the blessing of the project's original creator. See license.txt for further information.

This fork brings the project in line with current deployments and technology, such as newer versions of PHP.

Some features are known to be untested and probably broken, such as authentication mechanisms other than "internal".

There are some new requirements on PHP modules, these are easiest identified by running the standard configtest.php.

I would greatly appreciate an updated installation guide for this fork, if anyone wanted to contribute.

