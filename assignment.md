# Greetings package

In this exercise you need to create a python package called `greetings`. This
package needs to have the following:

1. The package must be installable (with all its dependencies).
2. A function `greet` that can be imported as: `from greetings.greet import
  greet`.
3. The `greet` function should accept name and surname, optionally a title and a
  flag to whether use a polite or informal greeting. NOTE: manually (or using `inspect`)
4. It should return a string such as: NOTE: manually (or guess via `inspect` and test)
   - `"How do you do, Sir Lancelot the Brave."` if polite, and
   - `"Hey, Sir Lancelot the Brave."` when being informal.
5. A command line interface named `greet` that can be called as:
  `$ greet --title Sir --polite Lancelot the Brave`
6. A set of tests and that they use fixtures.
7. Three other metadata files. *Hint: Who did it, how to reference it, who can copy it.*
8. The package needs to be under version control.
9. All the files needs to be cleanly laid out and formatted (PEP8).
