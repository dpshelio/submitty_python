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

1. The `test_input` directory contains some examples of running some tests. All
   of them need the `helpers_functions.sh` file. It includes some functions that
   need to be repeated multiple times. For example, `setup_all` is needed for each
   tests as each test is independent of each other.

   Each file on this directory runs the "tests" for the question as numbered in
   the assignment instructions.
   - `01_01_install.sh` checks that it's installable (on the basic environment)
   - ...
   - `09_01_pep8.sh` runs linter (using the dev environment).
