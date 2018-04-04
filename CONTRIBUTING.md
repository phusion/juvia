# Contributors Guide

**Table of contents**

 * [Filing bug reports](#file_bugs)
 * [Contributing documentation](#contrib_docs)
 * [Contributing by bug triaging](#contrib_triag)
 * [Contributing community support](#contrib_support)
 * [Contributing code](#contrib_code)
 * [Pull requests](#pull_requests)

Thank you for your interest in Juvia - a [Phusion Passenger](https://www.phusionpassenger.com/) supported project. Juvia is open source and welcomes contributions. 
This guide gives you an overview of the ways with which you can contribute, as well as contribution guidelines.

You can contribute in one of the following areas:

 * Filing bugs.
 * Bug triage.
 * Documentation (user documentation, developer documentation, contributor documentation).
 * Community support.
 * Code.

Please submit patches in the form of a Github pull request.

<a name="file_bugs"></a>
## Filing bug reports

When filing a bug report, please ensure that you include the following information:
- What steps will reproduce the problem?
- What is the expected output? What do you see instead?
- What does your environment looks like (operating system, language, configuration, infrastructure)

__BONUS POINTS__
- Include files that provide context to the issue you're experiencing, like screenshots. For logs however, please create a GIST which is a paste of your full logs, and link that. Do NOT paste your full logs in issues, as that will make them very long and hard to read.
- If your project is public, link to the repo so we can investigate directly.

### Checklist
Before submitting your issue, please consider the following:
- Avoid using GitHub issues for questions or help. Submitting issues to this repository are reserved for bugs, feature requests, or changes to the source code.
- Check if the issue is not already reported. If you're experiencing an issue someone else has already reported, please add a comment to the existing issue so we can properly assess the gravity of the problem.
- Use labels appropriately (no more than 2 per issue).

<a name="contrib_docs"></a>
## Contributing documentation

Documentation can be found in the README for this project.

<a name="contrib_tiag"></a>
## Contributing by bug triaging

Users [file bug reports](https://github.com/phusion/juvia/issues) on a regular basis, but not all bug reports contain sufficient information, persist with new releases, are equally important, etc. By helping with bug triaging you make the lives of the core developers a lot easier.

To start contributing, please submit a comment on any bug report that needs triaging. This comment should contain triaging instructions, e.g. whether a report should be considered duplicate. If you contribute regularly we'll give you moderator access to the bug tracker so that you can apply triaging labels directly.

Here are some of the things that you should look for:

 * Some reports are duplicates of each other, i.e. they report the same issue. You should mark them as duplicate and note the ID of the original report.
 * Some reported problems are caused by the reporter's machine or the reporter's application. You should explain to them what the problem actually is, that it's not caused by Juvia, and then close the report.
 * Some reports need more information. At the very least, we need specific instructions on how to reproduce the problem. You should ask the reporter to provide more information. Some reporters reply slowly or not at all. If some time has passed, you should remind the reporter about the request for more information. But if too much time has passed and the issue cannot be reproduced, you should close the report and mark it as "Stale".
 * Some bug reports seem to be limited to one reporter, and it does not seem that other people suffer from the same problem. These are reports that need _confirmation_. You can help by trying to reproduce the problem.
 * Some reports are important, but have been neglected for too long. Although the core developers try to minimize the number of times this happens, sometimes it happens anyway because they're so busy. You should actively ping the core developers and remind them about it. Or better: try to actively find contributors who can help solving the issue.

**Always be polite to bug reporters.** Not all reporters are fluent in English, and not everybody may be tech-savvy. But we ask you for your patience and tolerance. We want to stimulate a positive and enjoyable environment.

<a name="contrib_support"></a>
## Contributing community support

You can contribute by answering support questions on [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=juvia).

<a name="contrib_code"></a>
##Contributing code

Juvia is mostly written in Ruby and Javascript, and makes use of Ruby gems. The source code is filled with inline comments, so look there if you want to understand how things work.

<a name="pull_requests"></a>
## Pull Requests

Please consider the following when creating a Pull Request (yay!):

### Reference an issue or milestone
Describe the big picture of your changes here to communicate to the maintainers why we should accept this pull request. If it fixes a bug or resolves a feature request, be sure to link to that issue.

You can bring up a list of suggested issues and pull requests within the repository by typing #. Type the issue or pull request number or title to filter the list, and then press either tab or enter to complete the highlighted result.

### Write a description of changes made
Provide a description of the changes proposed. Make sure to answer what types of changes your code introduces:
- Bugfix (non-breaking change which fixes an issue)
- New feature (non-breaking change which adds functionality)
- Breaking change (fix or feature that would cause existing functionality to not work as expected)

__BONUS POINTS__
- Check if the commit's or even all commits' message styles matches ours.
- Extend the repo's README / documentation, if applicable.

### Avoid breakage
- Pull requests should normally be submitted against the latest stable branch (e.g. master).
- Elaborate how you've tested your code.
- If this is a relatively large or complex change, kick off the discussion by explaining why you chose the solution you did and what alternatives you considered, etc...
