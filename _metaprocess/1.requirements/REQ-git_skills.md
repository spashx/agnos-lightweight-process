The instruction process AGNOS-sw-eng.v1.instructions.md shall include two agent SKILLs related to GIT operations specified in the process:

``` 
## START SESSION ACTION
7. Create with GIT a new branch for the session named `feature/<TRI>` where `<TRI>` is a text that the user HAS to provide to you. This branch shall be used for ALL changes in the session, including edits to existing files and creation of new files. If the branch already exists, ask the user on how to proceed.
```



``` 
### DEFINITION OF DONE - DoD (Delivery Checklist)
WHEN a task is done, add and commit with GIT all changes into the feature branch using this format:
  `<ADR>/<TASK> <description>`
Where `<ADR>` is the unique id of the ADR related to the task (if applicable), and `<TASK>` is the unique id of the task, and `<description>` a brief summary of changes. If no ADR is related, use `<TASK> <description>` (omit the `<ADR>/` prefix).
```


1) Implements a skill in th .gihub folder for each actions
2) validate the skills are working as expected - make some tests
3) Update the instruction process to us these skills