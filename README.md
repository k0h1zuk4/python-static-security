
## Summary

- Performs download of the informed repository;
- Scans known vulnerabilities in python dependencies using the Safety tool;
- Perform static analysis on the code using the Bandit tool;
- Search for keys and secrets within the repository's git structure using the Gitleaks tool.


## How to run

- Download the repository
``
$git clone python-static-security
``

- Enter the directory
``
$cd <reponame>
``

- Mount the Docker Image
``
$docker build.
``

- Run the image container generated in the previous step
``
$docker run -ti --name = "python-scan" <image id> <script parameters>
``

- Copy the output files inside the container to the host
``
$docker cp python-scan:/home/pythonscan/results .
``

- Access the results directory of the repository to access the outfiles with the results.
- Don't forget to remove the created container
``
$docker rm python-scan
``


## Script Params

| Param | Resume |
| ------------- | ------------- |
| `-gu` | Git username, must be sent in the format  **"username"**. This parameter is mandatory for the execution of the script |
| `-gp` | Git account password, must be sent in the format  **"password"**. This parameter is mandatory for the execution of the script |
| `-m` | Operating mode, send value **"static-scan"** to run only static analysis, **"dep-check"** to check dependencies and **"git-leaks"** to search for keys exposed in the git structure of your repository. If the parameter is not sent, all modes will be executed |
| `-r` | Evaluate specific repository and do not list default repositories |
| `-ro` | The  github account of who own the repository |
| `-h, --help` | Show a guide on the parameters and an example of use |

## Example of use
``
$ docker run -ti --name = "python-scan" 12ca0ef80295 -gu=username  -gp=password -m=dep-check -r=my-python-repo -ro=my-repo-owner
``

## Other infos
[Git Leaks](https://github.com/zricethezav/gitleaks) - Binary file version: 2.1.0

[Bandit](https://github.com/PyCQA/bandit)

[Safety](https://github.com/pyupio/safety)


