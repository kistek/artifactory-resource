# Artifactory Resource

Deploys and retrieves artifacts from a JFrog Artifactory server for a Concourse pipeline.

To define an Artifactory resource for a Concourse pipeline:

``` yaml
resource_types:
- name: artifactory
  type: docker-image
  source:
    repository: pivotalservices/artifactory-resource

resources:
- name: file-repository
  type: artifactory
  source:
    endpoint: http://ARTIFACTORY-HOST-NAME-GOES-HERE:8081/artifactory
    repository: "/repository-name/sub-folder"
    regex: "myapp-(?<version>.*).txt"
    username: YOUR-ARTIFACTORY-USERNAME
    password: YOUR-ARTIFACTORY-PASSWORD
    skip_ssl_verification: true
```

## Source Configuration

* `endpoint`: *Required.* The Artifactory REST API endpoint. eg. http://YOUR-HOST_NAME:8081/artifactory.  
* `repository`: *Required.* The Artifactory repository which includes any folder path, must contain a leading '/'. ```eg. /generic/product/pcf```  
* `regex`: *Required.* Regular expression used to extract artifact version, must contain 'version' group and match the entire filename. ```E.g. myapp-(?<version>.*).tar.gz```  
* `username`: *Optional.* Username for HTTP(S) auth when accessing an authenticated repository  
* `password`: *Optional.* Password for HTTP(S) auth when accessing an authenticated repository  
* `skip_ssl_verification`: *Optional.* Skip ssl verification when connecting to Artifactory's APIs. Values: ```true``` or ```false```(default).  

## Parameter Configuration

* `file`: *Required for put* The file to upload to Artifactory  
* `regex`: *Optional* overrides the source regex  
* `folder`: *Optional.* appended to the repository in source - must start with forward slash /  
* `properties`: *Optional for put* properties to associate with the upload
* `skip_download`: *Optional.* skip download of file. Useful for improving put performance by skipping the implicit get step using [get_params](https://concourse.ci/put-step.html#put-step-get-params).
* `sha256checksum`: *Optional for put* set the sha256 checksum when deploying. Values: ```true``` or ```false```(default).
* `forcesha256checksum`: *Optional for put* force setting the checksum using /api/checksum/sha256. Values: ```true``` or ```false```(default).
* `ignore_http_codes`: *Optional for put* For the file upload, this is an array of http response codes which will not be considered an error. Example values ```[404, 403]``` or ```[]```(default). This may be useful, for example, when artifactory returns a `404` if the artifact already exists.

Saving/deploying an artifact to Artifactory in a pipeline job:

``` yaml
  jobs:
  - name: build-and-save-to-artifactory
    plan:
    - task: build-a-file
      config:
        platform: linux
        image_resource:
          type: docker-image
          source:
            repository: ubuntu
        outputs:
        - name: build
        run:
          path: sh
          args:
          - -exc
          - |
            export DATESTRING=$(date +"%Y%m%d")
            echo "This is my file" > ./build/myapp-$(date +"%Y%m%d%H%S").txt
            find .
    - put: file-repository
      params: { file: ./build/myapp-*.txt }
        ignore_http_codes:
        - 404
```

Retrieving an artifact from Artifactory in a pipeline job:

``` yaml
jobs:
- name: trigger-when-new-file-is-added-to-artifactory
  plan:
  - get: file-repository
    trigger: true
  - task: use-new-file
    config:
      platform: linux
      image_resource:
        type: docker-image
        source:
          repository: ubuntu
      inputs:
      - name: file-repository
      run:
        path: echo
        args:
        - "Use file(s) from ./file-repository here..."
```

See [pipeline.yml](https://github.com/pivotalservices/artifactory-resource/blob/master/pipeline.yml) for an example of a full pipeline definition file.

## Resource behavior

### `check`: ...

Relies on the regex to retrieve artifact versions


### `in`: ...

Same as check, but retrieves the artifact based on the provided version


### `out`: Deploy to a repository.

Deploys the artifact.

#### Parameters

* `file`: *Required.* The path to the artifact to deploy.
* `properties`: *Optional.*  String list of properties.  See https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API#ArtifactoryRESTAPI-SetItemProperties
* `sha256checksum`: *Optional* set the sha256 checksum when deploying. Values: ```true``` or ```false```(default).
* `forcesha256checksum`: *Optional for put* force setting the checksum using /api/checksum/sha256. Values: ```true``` or ```false```(default).
* `ignore_http_codes`: *Optional for put* For the file upload, this is an array of http response codes which will not be considered an error. Example values ```[404, 403]``` or ```[]```(default). This may be useful, for example, when artifactory returns a `404` if the artifact already exists.

## Credits
This resource was originally based on the artifactory resource work of [mborges](https://github.com/mborges-pivotal/artifactory-resource).
