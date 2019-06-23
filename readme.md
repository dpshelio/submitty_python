# Submitty helpers (for python projects)

These steps were created as for our course we needed to
analyse submissions of how to create a python project.
That includes:
 - Checks that's installable;
 - Checks that includes the appropriate metadata;
 - Checks it runs as expected from a defined entry point;
 - Checks it runs as a package;
 - Checks its own tests;
 - Runs other tests;
 - ...

## How it is done within Submitty?

1. On the `provided_code` directory there is:

  - `create-env.sh` - a bash script that will generate two environments. A
    simple one for testing the installation of the submitted package works, a
    development one to run the tests and other analysis the submission. This
    needs to be run only when compiling the exercise.

