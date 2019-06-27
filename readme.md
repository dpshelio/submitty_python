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

The [assignment](./assignment.md) shows how that would be asked.

## How it is done within Submitty? (`config/`)

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

## Setup

After creating a course (`ccmcr19`):
```bash
# bash ~/create_course.sh # After modify coursename, and other fields.
# mkdir -p /var/local/submitty/private_course_repositories/submitty_courses/ccmcr19/hw01
```
go to the web and select course, click on new gradeable, fill the main information. Then you can either 
upload the exercise, either via the web or using scp:

- **web**: Create a zip directory with the config and all the directories.

- **ssh**: On the host,
  ```bash
  scp -i .vagrant/machines/ubuntu-18.04/virtualbox/private_key -r config/* root@192.168.56.111:/var/local/submitty/private_course_repositories/submitty_courses/ccmcr19/hw01
  ```
  and on the vm:
  ```bash
  # cd /var/local/submitty/private_course_repositories/submitty_courses/ccmcr19
  # chown -R instructor:ccmcr19 hw01
  ```

and then finally on the web:

- Create a new gradable (with manual marking too)
- Submission/Autograding: Full path - `/var/local/submitty/private_course_repositories/submitty_courses/ccmcr19/hw01`; no dates limits
- Back to the terminal but this time as instructor:
```bash
# su - instructor
instructor $ # Run the needed script to generate the environments
instructor $ cd /var/local/submitty/private_course_repositories/submitty_courses/ccmcr19/hw01/provided_code
instructor $ bash create_env.sh
instructor $ # Build the assignment
instructor $ cd ~/ccmcr19
instructor $ ./BUILD_ccmcr19.sh hw01
```
If it fails, read the [[NOTE]] below.



### NOTE about this process

The approach here removes one of the security fences Submitty has, which is to
not allow running bash programs. To dissable it you need to do it on:

```diff
diff --git a/grading/TestCase.cpp b/grading/TestCase.cpp
index 8a93cc2f..eeb2bbd5 100644
--- a/grading/TestCase.cpp
+++ b/grading/TestCase.cpp
@@ -311,7 +311,7 @@ const nlohmann::json TestCase::get_test_case_limits() const {
     // 10 seconds was sufficient time to compile most Data Structures
     // homeworks, but some submissions required slightly more time
     adjust_test_case_limits(_test_case_limits,RLIMIT_CPU,60);              // 60 seconds
-    adjust_test_case_limits(_test_case_limits,RLIMIT_FSIZE,10*1000*1000);  // 10 MB executable
+    adjust_test_case_limits(_test_case_limits,RLIMIT_FSIZE,50*1000*1000);  // 50 MB executable
 
     adjust_test_case_limits(_test_case_limits,RLIMIT_RSS,1000*1000*1000);  // 1 GB
   }
diff --git a/grading/execute.cpp b/grading/execute.cpp
index 856ff0f0..0558b166 100644
--- a/grading/execute.cpp
+++ b/grading/execute.cpp
@@ -142,6 +142,9 @@ bool system_program(const std::string &program, std::string &full_path_executabl
     // for Debugging
     { "strace",                  "/usr/bin/strace" },
     
+    // whitelist bash to run the commands for now
+    { "bash",                    "/bin/bash"},
+
     //Matlab
     { "matlab",                  "/usr/local/bin/matlab" }
 
```

Then it needs to be compiled again:
```bash
sudo /usr/local/submitty/.setup/INSTALL_SUBMITTY.sh restart_web
```
## Sample submissions (`submissions/`)

- `10001000.tar.gz` - All good, no git.
- `10001001.tar.gz` - Tests fail, one pep8 warning.
- `10001002.tar.gz` - All good, all clean (no artefacts).
