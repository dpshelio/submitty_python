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

  - `prepare_folder.sh` - File to run during the "compilation stage". It does few thinks:
     - The script searches for the submission, and checks it's the correct directory structure;
     - It then cleans the submission of artefacts (IDE files, python's, others);
     - It checks whether there are files for marking;
     - Packages the environments and the submission as `submission.tar.gz.out`.
       **NB** If the file is not called `*.out` then it's not moved to the
       execution phase.
